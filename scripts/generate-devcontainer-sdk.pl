#!/usr/bin/env perl

use strict;
use warnings;
use Cwd;

my (%targets, %architectures, %kernels);

$ENV{'TOPDIR'} = Cwd::getcwd();


sub parse_targetinfo {
	my ($target_dir, $subtarget) = @_;

	if (open M, "make -C '$target_dir' --no-print-directory DUMP=1 TARGET_BUILD=1 SUBTARGET='$subtarget' |") {
		my ($target_name, $target_arch, $target_kernel, $target_testing_kernel, @target_features);
		while (defined(my $line = readline M)) {
			chomp $line;

			if ($line =~ /^Target: (.+)$/) {
				$target_name = $1;
			}
			elsif ($line =~ /^Target-Arch-Packages: (.+)$/) {
				$target_arch = $1;
			}
			elsif ($line =~ /^Linux-Version: (\d\.\d+)\.\d+$/) {
				$target_kernel = $1;
			}
			elsif ($line =~ /^Linux-Testing-Version: (\d\.\d+)\.\d+$/) {
				$target_testing_kernel = $1;
			}
			elsif ($line =~ /^Target-Features: (.+)$/) {
				@target_features = split /\s+/, $1;
			}
			elsif ($line =~ /^@\@$/) {
				if ($target_name && $target_arch && $target_kernel &&
				    !grep { $_ eq 'broken' or $_ eq 'source-only' } @target_features) {
					$targets{$target_name} = $target_arch;
					$architectures{$target_arch} ||= [];
					push @{$architectures{$target_arch}}, $target_name;
					$kernels{$target_name} ||= [];
					push @{$kernels{$target_name}}, $target_kernel;
					if ($target_testing_kernel) {
						push @{$kernels{$target_name}}, $target_testing_kernel;
					}
				}

				undef $target_name;
				undef $target_arch;
				undef $target_kernel;
				undef $target_testing_kernel;
				@target_features = ();
			}
		}
		close M;
	}
}

sub get_targetinfo {
	foreach my $target_makefile (glob "target/linux/*/Makefile") {
		my ($target_dir) = $target_makefile =~ m!^(.+)/Makefile$!;
		my @subtargets;

		if (open M, "make -C '$target_dir' --no-print-directory DUMP=1 TARGET_BUILD=1 val.FEATURES V=s 2>/dev/null |") {
			if (defined(my $line = readline M)) {
				chomp $line;
				if (grep { $_ eq 'broken' or $_ eq 'source-only' } split /\s+/, $line) {
					next;
				}
			}
		}

		if (open M, "make -C '$target_dir' --no-print-directory DUMP=1 TARGET_BUILD=1 val.SUBTARGETS V=s 2>/dev/null |") {
			if (defined(my $line = readline M)) {
				chomp $line;
				@subtargets = split /\s+/, $line;
			}
			close M;
		}

		push @subtargets, 'generic' if @subtargets == 0;

		foreach my $subtarget (@subtargets) {
			parse_targetinfo($target_dir, $subtarget);
		}
	}
}

sub to_json_string($) {
       my $data = shift;

       if (ref($data) eq 'HASH') {
               my @entries;
               for my $key (sort keys %$data) {
                       my $value = $data->{$key};
                       my $value_str = to_json_string($value);
                       push @entries, qq["$key":$value_str];
               }
               return "{" . join(",", @entries) . "}";
       } elsif (ref($data) eq 'ARRAY') {
               my @entries = map { to_json_string($_) } @$data;
               return "[" . join(",", @entries) . "]";
       } elsif (defined $data && !ref($data)) {
               return qq["$data"];
       } else {
               return 'null';
       }
}

sub write_string_to_file {
    my ($filename, $string) = @_;

    open(my $fh, '>', $filename) or die "Could not open file '$filename' for writing: $!";
    print $fh $string;
    close($fh);
}

get_targetinfo();
my @branches = ( "main", "openwrt-22.03", "openwrt-23.05" );

for my $branch (sort @branches) {
	foreach my $target_arch (sort keys %architectures) {
		my $container = sprintf "ghcr.io/openwrt/sdk:$target_arch-$branch";
		my $dir = sprintf "%s/.devcontainer/sdk_%s_%s", Cwd::getcwd, $target_arch, $branch;
		my $json = {
			image => $container ,
			features => {},
			remoteUser => "buildbot",
		};
		system("mkdir", "-p", "$dir/");
		write_string_to_file("$dir/devcontainer.json", to_json_string($json));
	}
}
