"""
makeThumbnails.py
Convert plots to thumbnails
"""

import argparse
import os
import glob

def makeThumbnails(args):
    """ Read all cattables in inputDir and concatenate into outputMasterCat
    """
    for infile in sorted(glob.glob( os.path.join(args.inputDir, '*', 'spec_*dir'))):
        print infile
        head, tail = os.path.split(infile)
        for prefix in ['spec','nspec']:
            filename = tail.replace('spec', prefix).replace('.dir','_overlay.png')
            thumbnailFilename = os.path.join(infile, "thumb_" + filename)
            #if it already exists and --clobber =False
            if (args.clobber or not os.path.isfile(thumbnailFilename)):
                os.system('convert %s -thumbnail %s %s'%(os.path.join(infile, filename),
                                                         args.width,
                                                         os.path.join(infile, "thumb_" + filename)))


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("inputDir",
                        help = "input directory containing plate subdirectories")
    parser.add_argument("width",
                        help = "width of thumbnails in pixels")
    parser.add_argument("--clobber",
                        help = "overwrite existing thumbnails",
                        action = "store_true")

    args = parser.parse_args()
    print args
    makeThumbnails(args)