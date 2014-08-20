"""
makeCatTables.py
Read individual catfiles and convert to a master catalog
and tables for ingestion into the database.
"""

import argparse
import os
import glob

outputDatabaseFilesDir = 'dbOutputTables'
def concatenateCatfiles(args):
    """ Read all cattables in inputDir and concatenate into outputMasterCat
    """

    try:
        outputHandle = open(args.outputMasterCat, 'wb')
    except Exception, e:
        print e

    for infile in sorted(glob.glob( os.path.join(args.inputDir, '*', 'spec_*dir'))):
        print infile
        head, tail = os.path.split(infile)
        filename = tail.replace('spec', 'cat').replace('dir','dat')
        file = open(os.path.join(infile, filename), 'rb')
        readFour = False
        for line in file:
            if line.startswith('4'):
                readFour = True
            elif line.startswith('6'):
                break
            elif line.startswith('8'):
                break
            elif line.startswith('3 -2 0.00 0.00') and readFour:
                break
            outputHandle.write(line)

        outputHandle.write('\n')
        file.close()


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("inputDir",
                        help = "input directory containing plate subdirectories")
    parser.add_argument("outputMasterCat",
                        help = "output name of master catalog File")
    parser.add_argument("--usemaster",
                        help="use Master Cat file as input to generate database files.",
                        action = "store_true")
    args = parser.parse_args()


    if args.usemaster:
        print "Reading in ", args.outputMasterCat
    else:
        concatenateCatfiles(args)

    filename = str(args.outputMasterCat)
    masterFile = open(filename, 'r')

    if not os.path.isdir(outputDatabaseFilesDir):
        os.makedirs(outputDatabaseFilesDir)

    qso = open(os.path.join(outputDatabaseFilesDir,'qsos.txt'),'w')
    lines = open(os.path.join(outputDatabaseFilesDir,'lines.txt'),'w')
    systems = open(os.path.join(outputDatabaseFilesDir,'systems.txt'),'w')

    q = 0
    s = 0
    l = 0
    for line in masterFile:
        sp = line.rstrip().split()
        if len(sp) == 0:
            continue
        if (sp[0]=="1"):
            q = q+1
            readFour = False
            #1  272   94  51941 0.9374 0.9385 19.92   0   0 11.358 580.894 0 0.283 -23.7670 -1.0000 1.6 4.6 0.6 3.2
            qso.write("%d,%s" % (q, ','.join(sp[1:])))
        if(sp[0] == "4") and not readFour:
            readFour = True
            #append the W_limits and two null placeholders for specid and absystems 
            qso.write(",%s,\N,\N\n" % (','.join(sp[1:])))
        if(sp[0]=="3" and sp[1]!="-2"):
            s=s+1
            systems.write("%d,%d,%s\n" % (q, s, ','.join(sp[1:])))
        if(sp[0]=="5"):
            l=l+1
            "5 4446.94  0.549  0.084 1548.2    C   IV  0  -0.00000     0.00    6.5   3.31 *"
            "5 4455.75  0.802  0.095 1550.8    C   IV  0   0.00087   -85.87    8.5   4.04 0  1.878 C IV 1548.2"
            #['5', '6606.55', '3.362', '0.352', '2796.4', 'Mg', 'II', '0', '-0.00007', '7.56', '9.6', '4.38', '*']
            print >> lines, "%d,%d,%d,%s,%s-%s,%s" % (q, s, l, ','.join(sp[1:5]), sp[5],sp[6], ','.join(sp[7:12]))


    masterFile.close()
