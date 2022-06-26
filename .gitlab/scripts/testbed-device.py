#!/usr/bin/env python3

import argparse
import os
import sys
import logging

from labgrid import Environment, StepReporter
from labgrid.consoleloggingreporter import ConsoleLoggingReporter


class TestbedDevice:
    def __init__(self, args):
        self.args = args
        self.env = Environment(config_file=self.args.config)
        ConsoleLoggingReporter.start(args.console_logpath)
        self.target = self.env.get_target(args.target)

    def boot_into(self):
        strategy = self.target.get_driver("UBootStrategy")
        dest = self.args.destination
        if dest == "shell":
            strategy.transition("shell")
        if dest == "bootloader":
            strategy.transition("uboot")

    def power(self):
        power = self.target.get_driver("PowerProtocol")
        action = self.args.action
        if action == "on":
            power.on()
        if action == "off":
            power.off()
        if action == "cycle":
            power.cycle()

    def check_network(self):
        host = self.args.remote_host
        network = self.args.network
        shell = self.target.get_driver("ShellDriver")
        shell.wait_for(
            'ifstatus {} | jsonfilter -qe "@.up" || true'.format(network), "true", 60.0
        )

        shell.wait_for("ping -c1 {} || true".format(host), ", 0% packet loss", 90.0)


def main():
    logging.basicConfig(
        level=logging.INFO, format="%(levelname)7s: %(message)s", stream=sys.stderr
    )

    parser = argparse.ArgumentParser()
    parser.add_argument(
        "-c",
        "--config",
        type=str,
        default=os.environ.get("TB_CONFIG", ".testbed/labgrid/default.yaml"),
        help="config file (default: %(default)s)",
    )
    parser.add_argument(
        "-t",
        "--target",
        type=str,
        default=os.environ.get("TB_TARGET", None),
        help="target device",
    )
    parser.add_argument(
        "-o",
        "--console-logpath",
        type=str,
        default=os.environ.get("TB_CONSOLE_LOGPATH", os.getcwd()),
        help="path for console logfile (default: %(default)s)",
    )
    parser.add_argument(
        "-v",
        "--verbose",
        action="count",
        default=int(os.environ.get("TB_VERBOSE", 0)),
        help="enable verbose mode",
    )
    parser.add_argument(
        "-d",
        "--debug",
        action="store_true",
        default=os.environ.get("TB_DEBUG"),
        help="enable debug mode",
    )

    subparsers = parser.add_subparsers(dest="command", title="available subcommands")

    subparser = subparsers.add_parser("power", help="control target power")
    subparser.add_argument(
        "action", choices=["on", "off", "cycle"], help="power on/off/cycle target"
    )
    subparser.set_defaults(func=TestbedDevice.power)

    subparser = subparsers.add_parser("boot_into", help="boot target into console")
    subparser.add_argument(
        "destination",
        choices=["shell", "bootloader"],
        help="boot target either into system shell or bootloader console",
    )
    subparser.set_defaults(func=TestbedDevice.boot_into)

    subparser = subparsers.add_parser(
        "check_network", help="ensure that network is usable"
    )
    subparser.add_argument(
        "-r",
        "--remote-host",
        default="192.168.1.2",
        help="remote host used for ping check (default: %(default)s)",
    )
    subparser.add_argument(
        "-n", "--network", default="lan", help="target network (default: %(default)s)"
    )
    subparser.set_defaults(func=TestbedDevice.check_network)

    args = parser.parse_args()
    if args.verbose >= 1:
        StepReporter.start()

    if args.debug:
        logging.getLogger().setLevel(logging.DEBUG)

    if not args.target:
        print("target device name is mandatory")
        exit(1)

    if not args.command:
        print("command is missing")
        exit(1)

    device = TestbedDevice(args)
    args.func(device)


if __name__ == "__main__":
    main()
