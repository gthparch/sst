#!/usr/bin/python

import sys
import os

def main(argv):
  autogen_cmd = "./autogen.sh"
  #configure_cmd = "./configure --enable-debug --prefix=$SST_HOME --with-boost=$BOOST_HOME --with-dramsim=$DRAMSIM2_HOME"
  configure_cmd = "./configure --prefix=$SST_HOME --with-boost=$BOOST_HOME --with-dramsim=$DRAMSIM2_HOME" 
  for argv in sys.argv[1:]:
    configure_cmd += ' ' + argv

  #optimization_flags = "CFLAGS=-O3 CXXFLAGS=-O3"
  optimization_flags = "CFLAGS=\"-O0 -g\" CXXFLAGS=\"-O0 -g\""
  configure_cmd += ' ' + optimization_flags
  #pintool_flags = "--with-pin=$PINTOOL_HOME"
  #configure_cmd += ' ' + pintool_flags

  make_cmd = "make -j12 all && make -j12 install"

  final_cmd = autogen_cmd + ' && ' + configure_cmd + ' && ' + make_cmd

  # Execute command
  os.system(final_cmd)

if __name__ == "__main__":
  main(sys.argv)
