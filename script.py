#!/usr/bin/python3


#! /usr/bin/env python3

import argparse
import sys
import getopt
import os
import re


def get_arguments():
    """ create argument parser for command line args """
    parser = argparse.ArgumentParser()
    parser.add_argument('-t', '--template', required=True)
    parser.add_argument('-o', '--output_file', required=True)
    
    return parser

def main(argv):
    """ 
        do it all - get arguments, determine run values, read template file
        and substitute in real values for placeholders
    """
   
    parser = get_arguments()
    args = parser.parse_args()
    print(args.output_file)
    
    with open(args.output_file, 'w') as o:
         o.write("hello world\n")
    

if __name__ == "__main__":
    main(sys.argv[1:])
