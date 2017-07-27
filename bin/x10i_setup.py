#!/usr/bin/env python3
import logging
LOG = logging.getLogger(__name__)
logging.basicConfig(level=logging.WARNING)

import os
import sys
import argparse
import subprocess
import shutil
import fileinput
from datetime import datetime

X10I_PATH = os.path.expanduser("~/git/x10i")
IRTSS_PATH = os.path.expanduser("~/git/irtss")

P = argparse.ArgumentParser(
    formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    description='Build x10i and iRTSS for certain systems.')
P.add_argument('target', nargs='?', default='i686-invasic-irtss',
    help='Target to build for')
P.add_argument('--debug', action='store_true',
    help='Show debug output')
P.add_argument('--skip-irtss', action='store_true',
    help='Do not build irtss')
P.add_argument('--visualize', action='store_true',
    help='Make agent system send out visualization data')
P.add_argument('--tilecount', type=int, metavar='T', default=4,
    help='Number of tiles')

ARGS = P.parse_args()
if ARGS.debug:
    LOG.setLevel(logging.DEBUG)

if not os.path.isdir(X10I_PATH):
    LOG.critical('No x10i found: '+X10I_PATH)
    sys.exit(1)
if not os.path.isdir(IRTSS_PATH):
    LOG.critical('No irtss found: '+IRTSS_PATH)
    sys.exit(1)

def exec(cmd, **kwargs):
    LOG.debug(cmd)
    LOG.debug(kwargs)
    r = subprocess.run(cmd, stdout=subprocess.PIPE,
            universal_newlines=True, **kwargs)
    if (r.returncode != 0):
        print(r.stdout)
    assert (r.returncode == 0)

TARGET_TO_ARCH = {
        'i686-invasic-irtss': 'x86guest',
        'i686-invasic-octopos': 'x86guest',
        'sparc-invasic-irtss': 'leon',
        }
VARIANT = {
        'x86guest': {
                4: 'generic',
                6: 'generic',
                8: 'generic',
            },
        'leon': {
                4: 'generic-swcpy-w-iotile',
            }
        }

def config_irtss():
    with fileinput.input('src/lib/debug-cfg.h', inplace=True) as f:
        for line in f:
            print(line.replace('SUB_AGENT_TELEMETRY_ON  1',
                    'SUB_AGENT_TELEMETRY_ON  0'), end='')
    if ARGS.visualize:
        assert (ARGS.target == 'i686-invasic-irtss')
        with fileinput.input('app/release.x86guest.multitile/release.x86guest.multitile.config', inplace=True) as f:
            for line in f:
                print(line.replace('# CONFIG_cf_gui_enabled is not set',
                        'CONFIG_cf_gui_enabled=y'), end="")
    else: # undo previous visualize, potentially
        with fileinput.input('app/release.x86guest.multitile/release.x86guest.multitile.config', inplace=True) as f:
            for line in f:
                print(line.replace('CONFIG_cf_gui_enabled=y',
                    '# CONFIG_cf_gui_enabled is not set'), end="")

def build_irtss():
    arch = TARGET_TO_ARCH[ARGS.target]
    variant = VARIANT[arch][ARGS.tilecount]
    LOG.debug("chdir "+IRTSS_PATH)
    os.chdir(IRTSS_PATH)
    config_irtss()
    # Building iRTSS
    if ARGS.skip_irtss:
        LOG.info("skip irtss build")
    else:
        LOG.info('Build %s.%s' % (arch, variant))
        env = {
                'PATH': ':'.join((
                    '/data1/zwinkau/sparc-elf-6.1.0/bin',
                    os.path.join(IRTSS_PATH, 'tools/bin'),
                    os.path.expanduser('~/bin'),
                    '/usr/sbin:/sbin:/usr/bin:/bin')),
            }
        exec('platform/generateVariants.sh', env=env)
        cmd = 'build4platform.pl platform/release.{arch}.{variant}.pm'
        exec(cmd.format(**locals()), env=env, shell=True)
    # Now install to x10i
    LOG.info('Install to %s' % (X10I_PATH,))
    install_dir = os.path.join(X10I_PATH, 'octopos-app/releases/')
    date = datetime.strftime(datetime.now(), '%Y-%m-%d')
    tgt = os.path.join(install_dir, date)
    if os.path.isdir(tgt):
        shutil.rmtree(tgt)
    shutil.copytree(os.path.join('releases/git/', arch),
            os.path.join(tgt, arch))
    os.chdir(install_dir)
    LOG.debug("chdir "+install_dir)
    if os.path.exists('current'):
        os.remove('current')
    LOG.debug("symlink current -> %s" % (date,))
    os.symlink(date, 'current')
    d = (os.path.join('current', arch))
    os.chdir(d)
    LOG.debug("chdir "+d)
    if os.path.exists('default'):
        shutil.rmtree('default')
    LOG.debug("symlink default -> %s" % (variant,))
    os.symlink(variant, 'default')

def build_x10i():
    os.chdir(os.path.join(X10I_PATH, 'x10.dist'))
    LOG.info("Build x10i %s" % (ARGS.target,))
    exec('ant dist-firm -DTARGET='+ARGS.target, shell=True)

build_irtss()
build_x10i()
print("Now use `x10-firm -mtarget=%s`" % (ARGS.target,))
