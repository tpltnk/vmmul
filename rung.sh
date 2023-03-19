#!/usr/bin/env bash

VCD=${1:-"mmul"}

gtkwave $VCD.vcd
