#!/bin/bash -f
# ****************************************************************************
# Vivado (TM) v2020.1 (64-bit)
#
# Filename    : elaborate.sh
# Simulator   : Xilinx Vivado Simulator
# Description : Script for elaborating the compiled design
#
# Generated by Vivado on Thu Aug 20 12:10:06 EDT 2020
# SW Build 2902540 on Wed May 27 19:54:35 MDT 2020
#
# Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
#
# usage: elaborate.sh
#
# ****************************************************************************
set -Eeuo pipefail
echo "xelab -wto ba5bf3e6c0dc444b92b2876739d2b41f --incr --debug typical --relax --mt 8 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot alu_tb_behav xil_defaultlib.alu_tb xil_defaultlib.glbl -log elaborate.log"
xelab -wto ba5bf3e6c0dc444b92b2876739d2b41f --incr --debug typical --relax --mt 8 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot alu_tb_behav xil_defaultlib.alu_tb xil_defaultlib.glbl -log elaborate.log

