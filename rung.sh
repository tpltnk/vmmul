#!/usr/bin/env bash

VCD=${1:-"mmul_tb"}

gtkwave $VCD.vcd
