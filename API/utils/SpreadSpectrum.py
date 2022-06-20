import cv2
from PIL import Image
import array
import numpy as np
from numpy import *
from random import gauss
from random import seed

def encode_image(message):
    g = message
    leng_msg = len(g)
    print(leng_msg)
    i = 0
    a = list()
    for i in range(leng_msg):
        a.append(0)
    j = 0
    
    for i in g:
        a[j] = ord(i)
        j+=1
    msg_biner = [[0 for i in range(8)] for j in range(leng_msg)]
    # print(msg_biner)
    j = 0
    i = 7
    while(j<leng_msg):
        while(i>-1):
            msg_biner[j][i] = a[j]%2
            a[j] = (a[j] - msg_biner[j][i])//2
            i -= 1
        j+= 1
        i = 7
    print(msg_biner)
    
    i = 0
    j = 0
    while(j<leng_msg):
        while(i<8):
            if msg_biner[j][i] == 0:
                msg_biner[j][i] =0
            elif msg_biner[j][i] == 1:
                msg_biner[j][i] == 1
            i += 1
        j += 1
        i = 0
    i = 0
    j = 0
    
    path = r'./image_toencode.png'
    grap = cv2.imread(path)
    
    leng_image = len(grap)
    print(leng_image)
    
    b = [[0 for i in range(8)] for j in range(leng_image)]
    while(j< leng_image):
        while(i<8):
            b[j][i] = grap[j,i,2]
            i += 1
        j += 1
        i = 0
    
    Bi = [[0 for i in range(8)] for j in range(leng_image*8)]
    
    j = 0
    i = 7
    k = 0
    while(j<leng_image):
        while(k<8):
            while(i>-1):
                if(j>0):
                    Bi[k + (8*j)][i] = b[j][k]%2
                    b[j][k] = (b[j][k] - Bi[k + (8*j)][i])//2
                else:
                    Bi[k][i] = b[j][k]%2
                    b[j][k] = (b[j][k] -  Bi[k][i])//2
                i -= 1
            k += 1
            i = 7
        j += 1
        k = 0
    
    keydum = '01234567'
    
    if(leng_msg == 39):
        key = keydum + keydum + keydum + keydum + '0123456'
    elif(leng_msg == 41):
        key = keydum + keydum + keydum + keydum +  keydum + '0'
    elif(leng_msg == 42):
        key = keydum + keydum + keydum + keydum +  keydum + '01'
    elif(leng_msg == 43):
        key = keydum + keydum + keydum + keydum +  keydum + '012'
    elif(leng_msg == 44):
        key = keydum + keydum + keydum + keydum +  keydum + '0123'
    elif(leng_msg == 45):
        key = keydum + keydum + keydum + keydum +  keydum + '01234'
    elif(leng_msg == 46):
        key = keydum + keydum + keydum + keydum +  keydum + '012345'
    elif(leng_msg == 47):
        key = keydum + keydum + keydum + keydum +  keydum + '0123456'
    elif(leng_msg == 48):
        key = keydum + keydum + keydum + keydum +  keydum + '01234567'
    else:
        key = keydum + keydum + keydum + keydum +  keydum
        
    # print('key : ', key)
    
    leng_key1 = len(key)
    
    o = list()
    for i in range(leng_key1):
        o.append(0)
    j = 0
    
    for i in key:
        o[j] = int(i)
        j += 1
    j = 0
    i = 0
    
    while(j< leng_key1):
        for l in o:
            if i>7:
                i = 0
            elif j> 0 :
                Bi[l + (8*j)][7] = msg_biner[j][i]
            else:
                Bi[l][7] = msg_biner[j][i]
            i +=1
        j +=1
        i = 0
    
    print('Bi', Bi[0])
    u = 0
    v = 0
    
    seed(1)
    series1r = [gauss(0.0, 1.0) for i in range(leng_image*8)]
    
    series = reshape(series1r,(leng_image, 8))
    
    mini = min(series1r)
    
    z = series - mini
    
    maxi = z.max()
    
    q = maxi/2**7
    
    audio = fix(z/q)
    
    signal1 = audio/audio.max()
    
    signal = [[ 0 for i in range(8)] for j in range(leng_image)]
    keycar = '0123456701234567012345670123456701234567012345670123456701234567'
    key2 = keycar + keycar + keycar + keycar + keycar + keycar
    
    leng_key2 = len(key2)
    q = list()
    for i in range(leng_key2):
        q.append(0)
    w = 0
    for v in key2:
        q[w] = int(v)
        w+=1
    w = 0
    v = 0
    
    j = 0
    i = 0
    l = 0
    while(j<leng_key2):
        for l in q:
            if i>7:
                i = 0
            else:
                signal[j][i] = signal1[j][l]
            i += 1
            l += 1
        l = q[0]
        j += 1
        l = 0
    
    s = [[0 for i in range(8)] for j in range(leng_image)]
    while(u<leng_image):
        while(v<8):
            s[u][v]= Bi[u][v]*signal[u][v]
            v += 1
        u += 1
        v = 0
    u = 0
    v = 0
    
    t =[[ 0 for i in range(8)] for j in range(leng_image)]
    key3 = '01234567'
    length = len(key3)
    p = list();
    for i in range(length):
        p.append(0)
    w = 0
    for v in key3:
        p[w] = int(v)
        w += 1
    w = 0
    v = 0
    
    j = 0
    i = 0
    l = 0
    while(j<leng_image):
        for l in p:
            if i>7:
                i = 0
            else:
                t[j][i] = s[j][l]
            i += 1
            l += 1
        l = p[0]
        j += 1
        i = 0
    
    ta = [[ 0 for i in range(8)] for k in range(leng_image)]
    k = 0
    i = 0
    while(k<leng_image):
        for i in range(8):
            ta[k][i] = (t[k][i])*(2**8)
            i += 1
        k += 1
        i = 0
        
    for i in range(leng_image):
        for j in range(8):
            grap[i, j, 2] = ta[i][j]
            
    cv2.imwrite('encoded_image.png', grap)
    





def decode_image():
    path = r'./image_todecode.png'
    grap = cv2.imread(path)

    row_image = len(grap)
    ta = [[0 for i in range(8)] for j in range(row_image)]
    i = 0
    j = 0

    while(j<row_image):
        while(i<8):
            ta[j][i] = grap[j,i,2]
            i += 1
        j += 1
        i = 0
    
    tb = [[0  for i in range(8)] for k in range(row_image)]
    k = 0
    i = 0
    while(k<row_image):
        for i in range(8):
            if i == 0:
                ta[k][i] = -1*(256 - ta[k][i])
            tb[k][i] = (ta[k][i]/(2**8))
            i += 1
        k += 1
        i = 0
    
    sr = [[0 for i in range(8)] for j in range(row_image)]
    key3 = '01234567'
    length = len(key3)
    p = list();
    for i in range(length):
        p.append(0)
    w = 0
    for v in key3:
        p[w] = int(v)
        w+=1
    w = 0
    v = 0

    j = 0
    i = 0
    l = 0

    while(j<row_image):
        for l in p:
            if i>7:
                i = 0
            else:
                sr[j][i] = tb[j][i]
            i += 1
            l += 1
        l = p[0]
        j += 1
        i = 0
    o = 0
    p = 0
    seed(1)
    series1r = [gauss(0.0, 1.0) for i in range(row_image*8)]
    seriesr = reshape(series1r,(row_image, 8))

    minir = seriesr.min()
    zr = seriesr-minir
    maxir = zr.max()
    qr = maxir/2**7
    imager = fix(zr/qr)

    signal1r = imager/imager.max()

    signalr = [[0 for i in range(8)] for j in range(row_image)]
    keycar = '012345670123456701234567012345670123456701234567'
    key2 = keycar + keycar + keycar + keycar + keycar + keycar
    lengt = len(key2)
    qr = list();
    for i in range(lengt):
        qr.append(0)
    w=0
    for p in key2:
        qr[w] = int(p)
        w += 1
    w = 0
    p = 0

    j = 0
    i = 0
    l = 0

    while(j< row_image):
        for l in qr:
            if i>7:
                i = 0
            else:
                signalr[j][i] = (signal1r[j][l])
            i += 1
            l += 1
        l = qr[0]
        j += 1
        i = 0
    Bir = [[0 for i in range(8)] for j in range(row_image)]
    while(o<row_image):
        while(p<8):
            try:
                Bir[o][p] = ((sr[o][p]/signalr[o][p]))
            except:
                Bir[o][p] = 0
            p += 1
        o += 1
        p = 0
    o = 0
    p = 0
    # print('Bir : ',Bir[0:8])
    
    keydum = '01234567'
    key = keydum + keydum + keydum + keydum + keydum + '01'
    lenge = len(key)
    o = list()
    for i in range(lenge):
        o.append(0)
    j = 0
    
    for i in key:
        o[j] = int(i)
        j += 1
    j = 0
    i = 0

    bir = [[0 for i in range(8)] for j in range(row_image//8)]

    while(j< row_image//8):
        for l in o:
            if i>7:
                i = 0
            if j>0:
                bir[j][i] =  Bir[l + (8*j)][7]
            else:
                bir[j][i] = Bir[l][7]
            i += 1
        j += 1
        i = 0

    # print('bir : ', bir)
    var = [0 for i in range(row_image//8)]
    i = 7
    j = 0

    while(j<row_image/32):
        sommy = 0
        while(i>-1):
            sommy += ((bir[j][i] * (2**(7-i))))
            i-= 1
        var[j] = sommy
        j += 1
        i = 7
    i = 0
    j = 0

    varcharfix = ''
    print('fix var[i]', var)

    for i in range(row_image//32):
        print('var[1] : ', var[1])
        a = np.array([42, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57])
        if ((var[i] != a).all()) :
            break
        else:
            varchar = chr(int(var[i]))
            varcharfix += varchar

    # print('varchar : ', varcharfix)
    # for i in range(row_image//32):
        # print('var[i] : ', var[i])
        # a = np.array([42, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57])
        # if np.logical_and(var[i], a) :
        #     varchar = chr(int(var[i]))
        #     varcharfix += varchar
        #     # print('break boss')
        # else:
        #     break
            

    # print(varcharfix)
    return varcharfix




