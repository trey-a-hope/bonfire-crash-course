import json,os,struct,sys
M=json.load(open(os.path.join(os.path.dirname(os.path.abspath(__file__)), 'meta.json')))
T=M['types'];PT={int(k):v for k,v in M['ptype'].items()}
key2cls={v['key']:k for k,v in T.items() if v['key'] is not None}
def allprops(c):
  out={}
  while c in T:
    for n,k in T[c]['props'].items(): out[k]=n
    c=T[c]['parent']
  return out
b=open(sys.argv[1],'rb').read();p=0
def vu():
  global p;r=0;s=0
  while True:
    x=b[p];p+=1;r|=(x&127)<<s;s+=7
    if x<128:return r
assert b[:4]==b'RIVE';p=4
print('ver',vu(),vu(),'fileid',vu())
keys=[]
while True:
  k=vu()
  if k==0:break
  keys.append(k)
toc={}
for i,k in enumerate(keys):
  if i%4==0: w=struct.unpack_from('<I',b,p)[0];p+=4
  toc[k]=(w>>((i%4)*2))&3
print('toc',toc)
idx=0
while p<len(b):
  tk=vu();cls=key2cls.get(tk,'?%d'%tk);ap=allprops(cls)
  fields=[]
  while True:
    k=vu()
    if k==0:break
    t=PT.get(k)
    if t is None: t={0:'uint',1:'string',2:'double',3:'color'}[toc[k]]
    if t=='bool': v=b[p];p+=1
    elif t=='uint': v=vu()
    elif t=='double': v=round(struct.unpack_from('<f',b,p)[0],3);p+=4
    elif t=='color': v=hex(struct.unpack_from('<I',b,p)[0]);p+=4
    elif t in('string','bytes'):
      n=vu();v=b[p:p+n];p+=n;v=v.decode('utf8','replace') if t=='string' else '<%d bytes %s>'%(n,v.hex())
    else: raise Exception(t)
    fields.append('%s=%s'%(ap.get(k,k),v))
  print(idx,cls,' '.join(fields));idx+=1
