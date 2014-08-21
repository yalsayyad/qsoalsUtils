# Britt Lundgren
# August 20, 2014
#
# Interactive script for visually inspecting discrepant absorption line systems

def plot_box(someX, gradelab):
     # overplot shaded box
    x1 = 374.
    x2 = 2700.
    dx = x2-x1
    if someX<5110:
        xcent = x1+dx*((int(someX)-3800.)/(5110.-3800.))
        ycent = (755.+285.)/2.
    elif someX < 6850:
        xcent = x1+dx*((int(someX)-5110.)/(6850.-5110.))
        ycent = (1387.+857.)/2.
    else:
        xcent = x1+dx*((int(someX)-6850.)/(9225.-6850.))
        ycent = (2026.+1502.)/2.
    pl.gca().add_patch(Rectangle((xcent-75, ycent-350), 200, 600, facecolor="red", alpha=0.2))
    pl.text(xcent+15, ycent-150, gradelab, color='red')
    # print "plotting coords:"
    # print xcent, ycent
    
def plot_inter(line, fout):
    cols = line.split()
    answer='?'
    # plate-fiber-mjd  zqso imag zabs grade type CIV_ew1 CIV_ewer1 CIV_ew2 CIV_ewer2 beta BAL1 BAL2 VI notes
    plate = cols[0].split('-')[0]
    fiber = cols[0].split('-')[1]
    mjd = cols[0].split('-')[2]
    spec_norm = filedir+plate.zfill(4)+'/spec_'+plate.zfill(4)+'_'+fiber.zfill(3)+'_'+mjd+'.dir/norm__'+plate.zfill(4)+'_'+fiber.zfill(3)+'_'+mjd+'.png'
    spec = filedir+plate.zfill(4)+'/spec_'+plate.zfill(4)+'_'+fiber.zfill(3)+'_'+mjd+'.dir/DR7__'+plate.zfill(4)+'_'+fiber.zfill(3)+'_'+mjd+'.png'
    img = 'norm__'+plate.zfill(4)+'_'+fiber.zfill(3)+'_'+mjd+'.png'
    ospec = 'DR7__'+plate.zfill(4)+'_'+fiber.zfill(3)+'_'+mjd+'.png'
    nspec = 'norm__'+plate.zfill(4)+'_'+fiber.zfill(3)+'_'+mjd+'.png'
    # fetch spectra from Nazgul
    if not os.path.exists(nspec):
        os.system('wget --quiet --user=\'Sullivan\' --password=\'Doreen\' %s' % (spec_norm))
    if not os.path.exists(ospec):
        os.system('wget --quiet --user=\'Sullivan\' --password=\'Doreen\' %s' % (spec))

    if os.path.exists(img):
        pl.clf()
        pl.ion()
        imag = pl.imread(img)
        pl.imshow(imag)
        plot_box((1.+float(cols[3]))*1548.2, cols[4])
        pl.show()
    else:
        print "cannot find file: %s" % (img)
    good_replies = ['good', 'bad', 'unsure']
    comments=' '
    moveon = ['next', 'quit']
    print " "
    print "Inspecting grade %s C IV doublet at z=%.3f (%i A)" % (cols[4], float(cols[3]), int((1.+float(cols[3]))*1548.2))
    while answer not in moveon:
        reply = raw_input('Enter (g)ood, (j)unk, (u)nsure, (r)eplot, (c)omment, (n)ext, (q)uit: ')

        if reply.isdigit():
            print('Bad!' * 8)
        elif reply=='r':
            if img==nspec:
                img = ospec
            else:
                img = nspec
            pl.clf()
            pl.ion()
            imag = pl.imread(img)
            pl.imshow(imag)
            plot_box((1.+float(cols[3]))*1548.2, cols[4])
            pl.show()
        elif reply=='g':
            answer = 'good'
        elif reply=='j':
            answer = 'bad'
        elif reply=='u':
            answer = 'unsure'
        elif reply=='c':
            comments = raw_input('Enter comments: ')
        elif reply=='n':
            if answer not in good_replies:
                print "Please enter decision..."                
            else:
                print " "
                print "FINAL ANSWER: %s" % (answer)
                print " "
                print "Additional Comments: %s" % (comments)
                print " "
                print >> fout, "%s %s %s" % (line.strip(), answer, comments)
                answer = 'next'
                out=1
                break
        elif reply=='q':
            answer='quit'
            out=0
            break
        else:
            print('Bad input!')
    os.system("rm %s" % (nspec))
    os.system("rm %s" % (ospec))
    return(out)


import numpy as np
import matplotlib.pyplot as pl
import matplotlib.image as mpimg
from matplotlib.patches import Rectangle
import code
import readline
import atexit
import os

# set the directory where the plates are located
filedir = 'http://nazgul.uchicago.edu/sdssdr7/dr7/dr71_dat/'

# set the input file
filename = 'randsubset_dr7_absorbers_in_cooksey_notes.dat'
fout = open(filename+'_temp', 'w')
counter=0
printit = 0
com=1
firstline = 0
for line in open(filename).readlines():
    if line.startswith('#')==0:
        cols = line.split()

        # print out all lines already visually inspected
        if len(cols)>13:
            counter+=1
            printit=1
        elif com==1:
            if firstline==0:
                print " "
                print "%i systems in file already checked" % (counter)
            firstline=1
            com = plot_inter(line,fout)
            printit=0
        if com==0:
            printit=1
        if printit==1:
            print >> fout, "%s" % line.strip()
                
fout.close()

os.system("cp %s %s" % (filename+'_temp', filename))
            

