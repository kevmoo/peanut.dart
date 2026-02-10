(function dartProgram(){function copyProperties(a,b){var t=Object.keys(a)
for(var s=0;s<t.length;s++){var r=t[s]
b[r]=a[r]}}function mixinPropertiesHard(a,b){var t=Object.keys(a)
for(var s=0;s<t.length;s++){var r=t[s]
if(!b.hasOwnProperty(r)){b[r]=a[r]}}}function mixinPropertiesEasy(a,b){Object.assign(b,a)}var z=function(){var t=function(){}
t.prototype={p:{}}
var s=new t()
if(!(Object.getPrototypeOf(s)&&Object.getPrototypeOf(s).p===t.prototype.p))return false
try{if(typeof navigator!="undefined"&&typeof navigator.userAgent=="string"&&navigator.userAgent.indexOf("Chrome/")>=0)return true
if(typeof version=="function"&&version.length==0){var r=version()
if(/^\d+\.\d+\.\d+\.\d+$/.test(r))return true}}catch(q){}return false}()
function inherit(a,b){a.prototype.constructor=a
a.prototype["$i"+a.name]=a
if(b!=null){if(z){Object.setPrototypeOf(a.prototype,b.prototype)
return}var t=Object.create(b.prototype)
copyProperties(a.prototype,t)
a.prototype=t}}function inheritMany(a,b){for(var t=0;t<b.length;t++){inherit(b[t],a)}}function mixinEasy(a,b){mixinPropertiesEasy(b.prototype,a.prototype)
a.prototype.constructor=a}function mixinHard(a,b){mixinPropertiesHard(b.prototype,a.prototype)
a.prototype.constructor=a}function lazy(a,b,c,d){var t=a
a[b]=t
a[c]=function(){if(a[b]===t){a[b]=d()}a[c]=function(){return this[b]}
return a[b]}}function lazyFinal(a,b,c,d){var t=a
a[b]=t
a[c]=function(){if(a[b]===t){var s=d()
if(a[b]!==t){A.pR(b)}a[b]=s}var r=a[b]
a[c]=function(){return r}
return r}}function makeConstList(a,b){if(b!=null)A.QI(a,b)
a.$flags=7
return a}function convertToFastObject(a){function t(){}t.prototype=a
new t()
return a}function convertAllToFastObject(a){for(var t=0;t<a.length;++t){convertToFastObject(a[t])}}var y=0
function instanceTearOffGetter(a,b){var t=null
return a?function(c){if(t===null)t=A.qm(b)
return new t(c,this)}:function(){if(t===null)t=A.qm(b)
return new t(this,null)}}function staticTearOffGetter(a){var t=null
return function(){if(t===null)t=A.qm(a).prototype
return t}}var x=0
function tearOffParameters(a,b,c,d,e,f,g,h,i,j){if(typeof h=="number"){h+=x}return{co:a,iS:b,iI:c,rC:d,dV:e,cs:f,fs:g,fT:h,aI:i||0,nDA:j}}function installStaticTearOff(a,b,c,d,e,f,g,h){var t=tearOffParameters(a,true,false,c,d,e,f,g,h,false)
var s=staticTearOffGetter(t)
a[b]=s}function installInstanceTearOff(a,b,c,d,e,f,g,h,i,j){c=!!c
var t=tearOffParameters(a,false,c,d,e,f,g,h,i,!!j)
var s=instanceTearOffGetter(c,t)
a[b]=s}function setOrUpdateInterceptorsByTag(a){var t=v.interceptorsByTag
if(!t){v.interceptorsByTag=a
return}copyProperties(a,t)}function setOrUpdateLeafTags(a){var t=v.leafTags
if(!t){v.leafTags=a
return}copyProperties(a,t)}function updateTypes(a){var t=v.types
var s=t.length
t.push.apply(t,a)
return s}function updateHolder(a,b){copyProperties(b,a)
return a}var hunkHelpers=function(){var t=function(a,b,c,d,e){return function(f,g,h,i){return installInstanceTearOff(f,g,a,b,c,d,[h],i,e,false)}},s=function(a,b,c,d){return function(e,f,g,h){return installStaticTearOff(e,f,a,b,c,[g],h,d)}}
return{inherit:inherit,inheritMany:inheritMany,mixin:mixinEasy,mixinHard:mixinHard,installStaticTearOff:installStaticTearOff,installInstanceTearOff:installInstanceTearOff,_instance_0u:t(0,0,null,["$0"],0),_instance_1u:t(0,1,null,["$1"],0),_instance_2u:t(0,2,null,["$2"],0),_instance_0i:t(1,0,null,["$0"],0),_instance_1i:t(1,1,null,["$1"],0),_instance_2i:t(1,2,null,["$2"],0),_static_0:s(0,null,["$0"],0),_static_1:s(1,null,["$1"],0),_static_2:s(2,null,["$2"],0),makeConstList:makeConstList,lazy:lazy,lazyFinal:lazyFinal,updateHolder:updateHolder,convertToFastObject:convertToFastObject,updateTypes:updateTypes,setOrUpdateInterceptorsByTag:setOrUpdateInterceptorsByTag,setOrUpdateLeafTags:setOrUpdateLeafTags}}()
function initializeDeferredHunk(a){x=v.types.length
a(hunkHelpers,v,w,$)}var J={
Qu(a,b,c,d){return{i:a,p:b,e:c,x:d}},
ks(a){var t,s,r,q,p,o=a[v.dispatchPropertyName]
if(o==null)if($.B==null){A.h()
o=a[v.dispatchPropertyName]}if(o!=null){t=o.p
if(!1===t)return o.i
if(!0===t)return a
s=Object.getPrototypeOf(a)
if(t===s)return o.i
if(o.e===s)throw A.b(A.n("Return interceptor for "+A.d(t(a,o))))}r=a.constructor
if(r==null)q=null
else{p=$.z
if(p==null)p=$.z=v.getIsolateTag("_$dart_js")
q=r[p]}if(q!=null)return q
q=A.w(a)
if(q!=null)return q
if(typeof a=="function")return B.DG
t=Object.getPrototypeOf(a)
if(t==null)return B.ZQ
if(t===Object.prototype)return B.ZQ
if(typeof r=="function"){p=$.z
if(p==null)p=$.z=v.getIsolateTag("_$dart_js")
Object.defineProperty(r,p,{value:B.vB,enumerable:false,writable:true,configurable:true})
return B.vB}return B.vB},
ia(a){if(typeof a=="number"){if(Math.floor(a)==a)return J.im.prototype
return J.kD.prototype}if(typeof a=="string")return J.Dr.prototype
if(a==null)return J.CD.prototype
if(typeof a=="boolean")return J.yE.prototype
if(Array.isArray(a))return J.jd.prototype
if(typeof a!="object"){if(typeof a=="function")return J.c5.prototype
if(typeof a=="symbol")return J.Dw.prototype
if(typeof a=="bigint")return J.rQ.prototype
return a}if(a instanceof A.j)return a
return J.ks(a)},
w1(a){if(a==null)return a
if(Array.isArray(a))return J.jd.prototype
if(typeof a!="object"){if(typeof a=="function")return J.c5.prototype
if(typeof a=="symbol")return J.Dw.prototype
if(typeof a=="bigint")return J.rQ.prototype
return a}if(a instanceof A.j)return a
return J.ks(a)},
C(a){return J.ia(a)["["](a)},
CR(a){return J.ia(a).gh(a)},
I(a){return J.w1(a).gk(a)},
c(a,b){if(a==null)return b==null
if(typeof a!="object")return b!=null&&a===b
return J.ia(a).n(a,b)},
vB:function vB(){},
yE:function yE(){},
CD:function CD(){},
MF:function MF(){},
u0:function u0(){},
iC:function iC(){},
kd:function kd(){},
c5:function c5(){},
rQ:function rQ(){},
Dw:function Dw(){},
jd:function jd(a){this.$ti=a},
BC:function BC(){},
Po:function Po(a){this.$ti=a},
m:function m(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
qI:function qI(){},
im:function im(){},
kD:function kD(){},
Dr:function Dr(){}},A={FK:function FK(){},
k(a){var t,s
for(t=$.x.length,s=0;s<t;++s)if(a===$.x[s])return!0
return!1},
a:function a(a){this.a=a},
a7:function a7(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
SU:function SU(){},
NQ(a){var t=v.mangledGlobalNames[a]
if(t!=null)return t
return"minified:"+a},
wV(a,b){var t
if(b!=null){t=b.x
if(t!=null)return t}return u.p.b(a)},
d(a){var t
if(typeof a=="string")return a
if(typeof a=="number"){if(a!==0)return""+a}else if(!0===a)return"true"
else if(!1===a)return"false"
else if(a==null)return"null"
t=J.C(a)
return t},
u(a){var t,s,r,q
if(a instanceof A.j)return A.F(A.zK(a),null)
t=J.ia(a)
if(t===B.Ok||t===B.Ub||u.o.b(a)){s=B.O4(a)
if(s!=="Object"&&s!=="")return s
r=a.constructor
if(typeof r=="function"){q=r.name
if(typeof q=="string"&&q!=="Object"&&q!=="")return q}}return A.F(A.zK(a),null)},
i(a){var t,s,r
if(typeof a=="number"||A.y(a))return J.C(a)
if(typeof a=="string")return JSON.stringify(a)
if(a instanceof A.L)return a["["](0)
t=$.M()
for(s=0;s<1;++s){r=t[s].R(a)
if(r!=null)return r}return"Instance of '"+A.u(a)+"'"},
b(a){return A.r(a,new Error())},
r(a,b){var t
if(a==null)a=new A.E()
b.dartException=a
t=A.J
if("defineProperty" in Object){Object.defineProperty(b,"message",{get:t})
b.name=""}else b.toString=t
return b},
J(){return J.C(this.dartException)},
vh(a,b){throw A.r(a,b==null?new Error():b)},
l(a){throw A.b(A.o(a))},
f(a1){var t,s,r,q,p,o,n,m,l,k,j=a1.co,i=a1.iS,h=a1.iI,g=a1.nDA,f=a1.aI,e=a1.fs,d=a1.cs,c=e[0],b=d[0],a=j[c],a0=a1.fT
a0.toString
t=i?Object.create(new A.zx().constructor.prototype):Object.create(new A.rT(null,null).constructor.prototype)
t.$initialize=t.constructor
s=i?function static_tear_off(){this.$initialize()}:function tear_off(a2,a3){this.$initialize(a2,a3)}
t.constructor=s
s.prototype=t
t.$_name=c
t.$_target=a
r=!i
if(r)q=A.bx(c,a,h,g)
else{t.$static_name=c
q=a}t.$S=A.fm(a0,i,h)
t[b]=q
for(p=q,o=1;o<e.length;++o){n=e[o]
if(typeof n=="string"){m=j[n]
l=n
n=m}else l=""
k=d[o]
if(k!=null){if(r)n=A.bx(l,n,h,g)
t[k]=n}if(o===f)p=n}t.$C=p
t.$R=a1.rC
t.$D=a1.dV
return s},
fm(a,b,c){if(typeof a=="number")return a
if(typeof a=="string"){if(b)throw A.b("Cannot compute signature for static tearoff.")
return function(d,e){return function(){return e(this,d)}}(a,A.Tn)}throw A.b("Error in functionType of tearoff")},
vq(a,b,c,d){var t=A.yS
switch(b?-1:a){case 0:return function(e,f){return function(){return f(this)[e]()}}(c,t)
case 1:return function(e,f){return function(g){return f(this)[e](g)}}(c,t)
case 2:return function(e,f){return function(g,h){return f(this)[e](g,h)}}(c,t)
case 3:return function(e,f){return function(g,h,i){return f(this)[e](g,h,i)}}(c,t)
case 4:return function(e,f){return function(g,h,i,j){return f(this)[e](g,h,i,j)}}(c,t)
case 5:return function(e,f){return function(g,h,i,j,k){return f(this)[e](g,h,i,j,k)}}(c,t)
default:return function(e,f){return function(){return e.apply(f(this),arguments)}}(d,t)}},
bx(a,b,c,d){if(c)return A.Hf(a,b,d)
return A.vq(b.length,d,a,b)},
Z4(a,b,c,d){var t=A.yS,s=A.AO
switch(b?-1:a){case 0:throw A.b(new A.Eq("Intercepted function with no arguments."))
case 1:return function(e,f,g){return function(){return f(this)[e](g(this))}}(c,s,t)
case 2:return function(e,f,g){return function(h){return f(this)[e](g(this),h)}}(c,s,t)
case 3:return function(e,f,g){return function(h,i){return f(this)[e](g(this),h,i)}}(c,s,t)
case 4:return function(e,f,g){return function(h,i,j){return f(this)[e](g(this),h,i,j)}}(c,s,t)
case 5:return function(e,f,g){return function(h,i,j,k){return f(this)[e](g(this),h,i,j,k)}}(c,s,t)
case 6:return function(e,f,g){return function(h,i,j,k,l){return f(this)[e](g(this),h,i,j,k,l)}}(c,s,t)
default:return function(e,f,g){return function(){var r=[g(this)]
Array.prototype.push.apply(r,arguments)
return e.apply(f(this),r)}}(d,s,t)}},
Hf(a,b,c){var t,s
if($.Al==null)$.Al=A.L4("interceptor")
if($.i0==null)$.i0=A.L4("receiver")
t=b.length
s=A.Z4(t,c,a,b)
return s},
qm(a){return A.f(a)},
Tn(a,b){return A.cE(v.typeUniverse,A.zK(a.a),b)},
yS(a){return a.a},
AO(a){return a.b},
L4(a){var t,s,r,q=new A.rT("receiver","interceptor"),p=Object.getOwnPropertyNames(q)
p.$flags=1
t=p
for(p=t.length,s=0;s<p;++s){r=t[s]
if(q[r]===a)return r}throw A.b(new A.AT(!1,null,null,"Field name "+a+" not found."))},
e(a){return v.getIsolateTag(a)},
w(a){var t,s,r,q,p,o=$.NF.$1(a),n=$.nw[o]
if(n!=null){Object.defineProperty(a,v.dispatchPropertyName,{value:n,enumerable:false,writable:true,configurable:true})
return n.i}t=$.vv[o]
if(t!=null)return t
s=v.interceptorsByTag[o]
if(s==null){r=$.TX.$2(a,o)
if(r!=null){n=$.nw[r]
if(n!=null){Object.defineProperty(a,v.dispatchPropertyName,{value:n,enumerable:false,writable:true,configurable:true})
return n.i}t=$.vv[r]
if(t!=null)return t
s=v.interceptorsByTag[r]
o=r}}if(s==null)return null
t=s.prototype
q=o[0]
if(q==="!"){n=A.Va(t)
$.nw[o]=n
Object.defineProperty(a,v.dispatchPropertyName,{value:n,enumerable:false,writable:true,configurable:true})
return n.i}if(q==="~"){$.vv[o]=t
return t}if(q==="-"){p=A.Va(t)
Object.defineProperty(Object.getPrototypeOf(a),v.dispatchPropertyName,{value:p,enumerable:false,writable:true,configurable:true})
return p.i}if(q==="+")return A.Lc(a,t)
if(q==="*")throw A.b(A.n(o))
if(v.leafTags[o]===true){p=A.Va(t)
Object.defineProperty(Object.getPrototypeOf(a),v.dispatchPropertyName,{value:p,enumerable:false,writable:true,configurable:true})
return p.i}else return A.Lc(a,t)},
Lc(a,b){var t=Object.getPrototypeOf(a)
Object.defineProperty(t,v.dispatchPropertyName,{value:J.Qu(b,t,null,null),enumerable:false,writable:true,configurable:true})
return b},
Va(a){return J.Qu(a,!1,null,!!a.$iXj)},
VF(a,b,c){var t=b.prototype
if(v.leafTags[a]===true)return A.Va(t)
else return J.Qu(t,c,null,null)},
h(){if(!0===$.B)return
$.B=!0
A.Z1()},
Z1(){var t,s,r,q,p,o,n,m
$.nw=Object.create(null)
$.vv=Object.create(null)
A.kO()
t=v.interceptorsByTag
s=Object.getOwnPropertyNames(t)
if(typeof window!="undefined"){window
r=function(){}
for(q=0;q<s.length;++q){p=s[q]
o=$.x7.$1(p)
if(o!=null){n=A.VF(p,t[p],o)
if(n!=null){Object.defineProperty(o,v.dispatchPropertyName,{value:n,enumerable:false,writable:true,configurable:true})
r.prototype=o}}}}for(q=0;q<s.length;++q){p=s[q]
if(/^[A-Za-z_]/.test(p)){m=t[p]
t["!"+p]=m
t["~"+p]=m
t["-"+p]=m
t["+"+p]=m
t["*"+p]=m}}},
kO(){var t,s,r,q,p,o,n=B.Yq()
n=A.ud(B.KU,A.ud(B.fQ,A.ud(B.i7,A.ud(B.i7,A.ud(B.xi,A.ud(B.dk,A.ud(B.wb(B.O4),n)))))))
if(typeof dartNativeDispatchHooksTransformer!="undefined"){t=dartNativeDispatchHooksTransformer
if(typeof t=="function")t=[t]
if(Array.isArray(t))for(s=0;s<t.length;++s){r=t[s]
if(typeof r=="function")n=r(n)||n}}q=n.getTag
p=n.getUnknownTag
o=n.prototypeForTag
$.NF=new A.dC(q)
$.TX=new A.wN(p)
$.x7=new A.VX(o)},
ud(a,b){return a(b)||b},
Wk(a,b){var t=b.length,s=v.rttc[""+t+";"+a]
if(s==null)return null
if(t===0)return s
if(t===s.length)return s.apply(null,b)
return s(b)},
rY:function rY(){},
L:function L(){},
E1:function E1(){},
lc:function lc(){},
zx:function zx(){},
rT:function rT(a,b){this.a=a
this.b=b},
Eq:function Eq(a){this.a=a},
dC:function dC(a){this.a=a},
wN:function wN(a){this.a=a},
VX:function VX(a){this.a=a},
WZ:function WZ(){},
eH:function eH(){},
df:function df(){},
b0:function b0(){},
Dg:function Dg(){},
DV:function DV(){},
zU:function zU(){},
K8:function K8(){},
xj:function xj(){},
dE:function dE(){},
Zc:function Zc(){},
wf:function wf(){},
Pq:function Pq(){},
eE:function eE(){},
V6:function V6(){},
VR:function VR(){},
vX:function vX(){},
WB:function WB(){},
VS:function VS(){},
xZ(a,b){var t=b.c
return t==null?b.c=A.Q2(a,"b8",[b.x]):t},
Q1(a){var t=a.w
if(t===6||t===7)return A.Q1(a.x)
return t===11||t===12},
mD(a){return a.as},
q7(a){return A.Ew(v.typeUniverse,a,!1)},
PL(a0,a1,a2,a3){var t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a=a1.w
switch(a){case 5:case 1:case 2:case 3:case 4:return a1
case 6:t=a1.x
s=A.PL(a0,t,a2,a3)
if(s===t)return a1
return A.Bc(a0,s,!0)
case 7:t=a1.x
s=A.PL(a0,t,a2,a3)
if(s===t)return a1
return A.LN(a0,s,!0)
case 8:r=a1.y
q=A.bZ(a0,r,a2,a3)
if(q===r)return a1
return A.Q2(a0,a1.x,q)
case 9:p=a1.x
o=A.PL(a0,p,a2,a3)
n=a1.y
m=A.bZ(a0,n,a2,a3)
if(o===p&&m===n)return a1
return A.ap(a0,o,m)
case 10:l=a1.x
k=a1.y
j=A.bZ(a0,k,a2,a3)
if(j===k)return a1
return A.oP(a0,l,j)
case 11:i=a1.x
h=A.PL(a0,i,a2,a3)
g=a1.y
f=A.qT(a0,g,a2,a3)
if(h===i&&f===g)return a1
return A.Nf(a0,h,f)
case 12:e=a1.y
a3+=e.length
d=A.bZ(a0,e,a2,a3)
p=a1.x
o=A.PL(a0,p,a2,a3)
if(d===e&&o===p)return a1
return A.DS(a0,o,d,!0)
case 13:c=a1.x
if(c<a3)return a1
b=a2[c-a3]
if(b==null)return a1
return b
default:throw A.b(A.hV("Attempted to substitute unexpected RTI kind "+a))}},
bZ(a,b,c,d){var t,s,r,q,p=b.length,o=A.vU(p)
for(t=!1,s=0;s<p;++s){r=b[s]
q=A.PL(a,r,c,d)
if(q!==r)t=!0
o[s]=q}return t?o:b},
vO(a,b,c,d){var t,s,r,q,p,o,n=b.length,m=A.vU(n)
for(t=!1,s=0;s<n;s+=3){r=b[s]
q=b[s+1]
p=b[s+2]
o=A.PL(a,p,c,d)
if(o!==p)t=!0
m.splice(s,3,r,q,o)}return t?m:b},
qT(a,b,c,d){var t,s=b.a,r=A.bZ(a,s,c,d),q=b.b,p=A.bZ(a,q,c,d),o=b.c,n=A.vO(a,o,c,d)
if(r===s&&p===q&&n===o)return b
t=new A.ET()
t.a=r
t.b=p
t.c=n
return t},
QI(a,b){a[v.arrayRti]=b
return a},
JS(a){var t=a.$S
if(t!=null){if(typeof t=="number")return A.Bp(t)
return a.$S()}return null},
Ue(a,b){var t
if(A.Q1(b))if(a instanceof A.L){t=A.JS(a)
if(t!=null)return t}return A.zK(a)},
zK(a){if(a instanceof A.j)return A.Lh(a)
if(Array.isArray(a))return A.D(a)
return A.VU(J.ia(a))},
D(a){var t=a[v.arrayRti],s=u.b
if(t==null)return s
if(t.constructor!==s.constructor)return s
return t},
Lh(a){var t=a.$ti
return t!=null?t:A.VU(a)},
VU(a){var t=a.constructor,s=t.$ccache
if(s!=null)return s
return A.r9(a,t)},
r9(a,b){var t=a instanceof A.L?Object.getPrototypeOf(Object.getPrototypeOf(a)).constructor:b,s=A.ai(v.typeUniverse,t.name)
b.$ccache=s
return s},
Bp(a){var t,s=v.types,r=s[a]
if(typeof r=="string"){t=A.Ew(v.typeUniverse,r,!1)
s[a]=t
return t}return r},
RW(a){return A.Kx(A.Lh(a))},
tu(a){var t=a instanceof A.L?A.JS(a):null
if(t!=null)return t
if(u.R.b(a))return J.CR(a).a
if(Array.isArray(a))return A.D(a)
return A.zK(a)},
Kx(a){var t=a.r
return t==null?a.r=new A.lY(a):t},
xq(a){return A.Kx(A.Ew(v.typeUniverse,a,!1))},
JJ(a){var t=this
t.b=A.fr(t)
return t.b(a)},
fr(a){var t,s,r,q
if(a===u.K)return A.ke
if(A.cc(a))return A.Iw
t=a.w
if(t===6)return A.AQ
if(t===1)return A.JY
if(t===7)return A.fg
s=A.U5(a)
if(s!=null)return s
if(t===8){r=a.x
if(a.y.every(A.cc)){a.f="$i"+r
if(r==="zM")return A.yM
if(a===u.m)return A.xD
return A.t4}}else if(t===10){q=A.Wk(a.x,a.y)
return q==null?A.JY:q}return A.YO},
U5(a){if(a.w===8){if(a===u.S)return A.ok
if(a===u.i||a===u.H)return A.KH
if(a===u.N)return A.MM
if(a===u.y)return A.y}return null},
Au(a){var t=this,s=A.Oz
if(A.cc(t))s=A.hn
else if(t===u.K)s=A.Ti
else if(A.lR(t)){s=A.l4
if(t===u.t)s=A.Uc
else if(t===u.v)s=A.ra
else if(t===u.u)s=A.M4
else if(t===u.n)s=A.cU
else if(t===u.I)s=A.Qk
else if(t===u.z)s=A.wI}else if(t===u.S)s=A.IZ
else if(t===u.N)s=A.Bt
else if(t===u.y)s=A.p8
else if(t===u.H)s=A.z5
else if(t===u.i)s=A.rV
else if(t===u.m)s=A.AN
t.a=s
return t.a(a)},
YO(a){var t=this
if(a==null)return A.lR(t)
return A.t1(v.typeUniverse,A.Ue(a,t),t)},
AQ(a){if(a==null)return!0
return this.x.b(a)},
t4(a){var t,s=this
if(a==null)return A.lR(s)
t=s.f
if(a instanceof A.j)return!!a[t]
return!!J.ia(a)[t]},
yM(a){var t,s=this
if(a==null)return A.lR(s)
if(typeof a!="object")return!1
if(Array.isArray(a))return!0
t=s.f
if(a instanceof A.j)return!!a[t]
return!!J.ia(a)[t]},
xD(a){var t=this
if(a==null)return!1
if(typeof a=="object"){if(a instanceof A.j)return!!a[t.f]
return!0}if(typeof a=="function")return!0
return!1},
Vl(a){if(typeof a=="object"){if(a instanceof A.j)return u.m.b(a)
return!0}if(typeof a=="function")return!0
return!1},
Oz(a){var t=this
if(a==null){if(A.lR(t))return a}else if(t.b(a))return a
throw A.r(A.fT(a,t),new Error())},
l4(a){var t=this
if(a==null||t.b(a))return a
throw A.r(A.fT(a,t),new Error())},
fT(a,b){return new A.iM("TypeError: "+A.WK(a,A.F(b,null)))},
WK(a,b){return A.p(a)+": type '"+A.F(A.tu(a),null)+"' is not a subtype of type '"+b+"'"},
Lz(a,b){return new A.iM("TypeError: "+A.WK(a,b))},
fg(a){var t=this
return t.x.b(a)||A.xZ(v.typeUniverse,t).b(a)},
ke(a){return a!=null},
Ti(a){if(a!=null)return a
throw A.r(A.Lz(a,"Object"),new Error())},
Iw(a){return!0},
hn(a){return a},
JY(a){return!1},
y(a){return!0===a||!1===a},
p8(a){if(!0===a)return!0
if(!1===a)return!1
throw A.r(A.Lz(a,"bool"),new Error())},
M4(a){if(!0===a)return!0
if(!1===a)return!1
if(a==null)return a
throw A.r(A.Lz(a,"bool?"),new Error())},
rV(a){if(typeof a=="number")return a
throw A.r(A.Lz(a,"double"),new Error())},
Qk(a){if(typeof a=="number")return a
if(a==null)return a
throw A.r(A.Lz(a,"double?"),new Error())},
ok(a){return typeof a=="number"&&Math.floor(a)===a},
IZ(a){if(typeof a=="number"&&Math.floor(a)===a)return a
throw A.r(A.Lz(a,"int"),new Error())},
Uc(a){if(typeof a=="number"&&Math.floor(a)===a)return a
if(a==null)return a
throw A.r(A.Lz(a,"int?"),new Error())},
KH(a){return typeof a=="number"},
z5(a){if(typeof a=="number")return a
throw A.r(A.Lz(a,"num"),new Error())},
cU(a){if(typeof a=="number")return a
if(a==null)return a
throw A.r(A.Lz(a,"num?"),new Error())},
MM(a){return typeof a=="string"},
Bt(a){if(typeof a=="string")return a
throw A.r(A.Lz(a,"String"),new Error())},
ra(a){if(typeof a=="string")return a
if(a==null)return a
throw A.r(A.Lz(a,"String?"),new Error())},
AN(a){if(A.Vl(a))return a
throw A.r(A.Lz(a,"JSObject"),new Error())},
wI(a){if(a==null)return a
if(A.Vl(a))return a
throw A.r(A.Lz(a,"JSObject?"),new Error())},
io(a,b){var t,s,r
for(t="",s="",r=0;r<a.length;++r,s=", ")t+=s+A.F(a[r],b)
return t},
wT(a,b){var t,s,r,q,p,o,n=a.x,m=a.y
if(""===n)return"("+A.io(m,b)+")"
t=m.length
s=n.split(",")
r=s.length-t
for(q="(",p="",o=0;o<t;++o,p=", "){q+=p
if(r===0)q+="{"
q+=A.F(m[o],b)
if(r>=0)q+=" "+s[r];++r}return q+"})"},
bI(a0,a1,a2){var t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=", ",a=null
if(a2!=null){t=a2.length
if(a1==null)a1=A.QI([],u.s)
else a=a1.length
s=a1.length
for(r=t;r>0;--r)a1.push("T"+(s+r))
for(q=u.X,p="<",o="",r=0;r<t;++r,o=b){p=p+o+a1[a1.length-1-r]
n=a2[r]
m=n.w
if(!(m===2||m===3||m===4||m===5||n===q))p+=" extends "+A.F(n,a1)}p+=">"}else p=""
q=a0.x
l=a0.y
k=l.a
j=k.length
i=l.b
h=i.length
g=l.c
f=g.length
e=A.F(q,a1)
for(d="",c="",r=0;r<j;++r,c=b)d+=c+A.F(k[r],a1)
if(h>0){d+=c+"["
for(c="",r=0;r<h;++r,c=b)d+=c+A.F(i[r],a1)
d+="]"}if(f>0){d+=c+"{"
for(c="",r=0;r<f;r+=3,c=b){d+=c
if(g[r+1])d+="required "
d+=A.F(g[r+2],a1)+" "+g[r]}d+="}"}if(a!=null){a1.toString
a1.length=a}return p+"("+d+") => "+e},
F(a,b){var t,s,r,q,p,o,n=a.w
if(n===5)return"erased"
if(n===2)return"dynamic"
if(n===3)return"void"
if(n===1)return"Never"
if(n===4)return"any"
if(n===6){t=a.x
s=A.F(t,b)
r=t.w
return(r===11||r===12?"("+s+")":s)+"?"}if(n===7)return"FutureOr<"+A.F(a.x,b)+">"
if(n===8){q=A.o3(a.x)
p=a.y
return p.length>0?q+("<"+A.io(p,b)+">"):q}if(n===10)return A.wT(a,b)
if(n===11)return A.bI(a,b,null)
if(n===12)return A.bI(a.x,b,a.y)
if(n===13){o=a.x
return b[b.length-1-o]}return"?"},
o3(a){var t=v.mangledGlobalNames[a]
if(t!=null)return t
return"minified:"+a},
Qo(a,b){var t=a.tR[b]
while(typeof t=="string")t=a.tR[t]
return t},
ai(a,b){var t,s,r,q,p,o=a.eT,n=o[b]
if(n==null)return A.Ew(a,b,!1)
else if(typeof n=="number"){t=n
s=A.mZ(a,5,"#")
r=A.vU(t)
for(q=0;q<t;++q)r[q]=s
p=A.Q2(a,b,r)
o[b]=p
return p}else return n},
xb(a,b){return A.Ix(a.tR,b)},
FF(a,b){return A.Ix(a.eT,b)},
Ew(a,b,c){var t,s=a.eC,r=s.get(b)
if(r!=null)return r
t=A.eT(A.ow(a,null,b,!1))
s.set(b,t)
return t},
cE(a,b,c){var t,s,r=b.z
if(r==null)r=b.z=new Map()
t=r.get(c)
if(t!=null)return t
s=A.eT(A.ow(a,b,c,!0))
r.set(c,s)
return s},
v5(a,b,c){var t,s,r,q=b.Q
if(q==null)q=b.Q=new Map()
t=c.as
s=q.get(t)
if(s!=null)return s
r=A.ap(a,b,c.w===9?c.y:[c])
q.set(t,r)
return r},
BD(a,b){b.a=A.Au
b.b=A.JJ
return b},
mZ(a,b,c){var t,s,r=a.eC.get(c)
if(r!=null)return r
t=new A.Jc(null,null)
t.w=b
t.as=c
s=A.BD(a,t)
a.eC.set(c,s)
return s},
Bc(a,b,c){var t,s=b.as+"?",r=a.eC.get(s)
if(r!=null)return r
t=A.ll(a,b,s,c)
a.eC.set(s,t)
return t},
ll(a,b,c,d){var t,s,r
if(d){t=b.w
s=!0
if(!A.cc(b))if(!(b===u.P||b===u.T))if(t!==6)s=t===7&&A.lR(b.x)
if(s)return b
else if(t===1)return u.P}r=new A.Jc(null,null)
r.w=6
r.x=b
r.as=c
return A.BD(a,r)},
LN(a,b,c){var t,s=b.as+"/",r=a.eC.get(s)
if(r!=null)return r
t=A.eV(a,b,s,c)
a.eC.set(s,t)
return t},
eV(a,b,c,d){var t,s
if(d){t=b.w
if(A.cc(b)||b===u.K)return b
else if(t===1)return A.Q2(a,"b8",[b])
else if(b===u.P||b===u.T)return u.O}s=new A.Jc(null,null)
s.w=7
s.x=b
s.as=c
return A.BD(a,s)},
Hc(a,b){var t,s,r=""+b+"^",q=a.eC.get(r)
if(q!=null)return q
t=new A.Jc(null,null)
t.w=13
t.x=b
t.as=r
s=A.BD(a,t)
a.eC.set(r,s)
return s},
Ux(a){var t,s,r,q=a.length
for(t="",s="",r=0;r<q;++r,s=",")t+=s+a[r].as
return t},
S4(a){var t,s,r,q,p,o=a.length
for(t="",s="",r=0;r<o;r+=3,s=","){q=a[r]
p=a[r+1]?"!":":"
t+=s+q+p+a[r+2].as}return t},
Q2(a,b,c){var t,s,r,q=b
if(c.length>0)q+="<"+A.Ux(c)+">"
t=a.eC.get(q)
if(t!=null)return t
s=new A.Jc(null,null)
s.w=8
s.x=b
s.y=c
if(c.length>0)s.c=c[0]
s.as=q
r=A.BD(a,s)
a.eC.set(q,r)
return r},
ap(a,b,c){var t,s,r,q,p,o
if(b.w===9){t=b.x
s=b.y.concat(c)}else{s=c
t=b}r=t.as+(";<"+A.Ux(s)+">")
q=a.eC.get(r)
if(q!=null)return q
p=new A.Jc(null,null)
p.w=9
p.x=t
p.y=s
p.as=r
o=A.BD(a,p)
a.eC.set(r,o)
return o},
oP(a,b,c){var t,s,r="+"+(b+"("+A.Ux(c)+")"),q=a.eC.get(r)
if(q!=null)return q
t=new A.Jc(null,null)
t.w=10
t.x=b
t.y=c
t.as=r
s=A.BD(a,t)
a.eC.set(r,s)
return s},
Nf(a,b,c){var t,s,r,q,p,o=b.as,n=c.a,m=n.length,l=c.b,k=l.length,j=c.c,i=j.length,h="("+A.Ux(n)
if(k>0){t=m>0?",":""
h+=t+"["+A.Ux(l)+"]"}if(i>0){t=m>0?",":""
h+=t+"{"+A.S4(j)+"}"}s=o+(h+")")
r=a.eC.get(s)
if(r!=null)return r
q=new A.Jc(null,null)
q.w=11
q.x=b
q.y=c
q.as=s
p=A.BD(a,q)
a.eC.set(s,p)
return p},
DS(a,b,c,d){var t,s=b.as+("<"+A.Ux(c)+">"),r=a.eC.get(s)
if(r!=null)return r
t=A.hw(a,b,c,s,d)
a.eC.set(s,t)
return t},
hw(a,b,c,d,e){var t,s,r,q,p,o,n,m
if(e){t=c.length
s=A.vU(t)
for(r=0,q=0;q<t;++q){p=c[q]
if(p.w===1){s[q]=p;++r}}if(r>0){o=A.PL(a,b,s,0)
n=A.bZ(a,c,s,0)
return A.DS(a,o,n,c!==n)}}m=new A.Jc(null,null)
m.w=12
m.x=b
m.y=c
m.as=d
return A.BD(a,m)},
ow(a,b,c,d){return{u:a,e:b,r:c,s:[],p:0,n:d}},
eT(a){var t,s,r,q,p,o,n,m=a.r,l=a.s
for(t=m.length,s=0;s<t;){r=m.charCodeAt(s)
if(r>=48&&r<=57)s=A.A(s+1,r,m,l)
else if((((r|32)>>>0)-97&65535)<26||r===95||r===36||r===124)s=A.R8(a,s,m,l,!1)
else if(r===46)s=A.R8(a,s,m,l,!0)
else{++s
switch(r){case 44:break
case 58:l.push(!1)
break
case 33:l.push(!0)
break
case 59:l.push(A.KQ(a.u,a.e,l.pop()))
break
case 94:l.push(A.Hc(a.u,l.pop()))
break
case 35:l.push(A.mZ(a.u,5,"#"))
break
case 64:l.push(A.mZ(a.u,2,"@"))
break
case 126:l.push(A.mZ(a.u,3,"~"))
break
case 60:l.push(a.p)
a.p=l.length
break
case 62:A.rD(a,l)
break
case 38:A.I3(a,l)
break
case 63:q=a.u
l.push(A.Bc(q,A.KQ(q,a.e,l.pop()),a.n))
break
case 47:q=a.u
l.push(A.LN(q,A.KQ(q,a.e,l.pop()),a.n))
break
case 40:l.push(-3)
l.push(a.p)
a.p=l.length
break
case 41:A.Mt(a,l)
break
case 91:l.push(a.p)
a.p=l.length
break
case 93:p=l.splice(a.p)
A.cH(a.u,a.e,p)
a.p=l.pop()
l.push(p)
l.push(-1)
break
case 123:l.push(a.p)
a.p=l.length
break
case 125:p=l.splice(a.p)
A.G(a.u,a.e,p)
a.p=l.pop()
l.push(p)
l.push(-2)
break
case 43:o=m.indexOf("(",s)
l.push(m.substring(s,o))
l.push(-4)
l.push(a.p)
a.p=l.length
s=o+1
break
default:throw"Bad character "+r}}}n=l.pop()
return A.KQ(a.u,a.e,n)},
A(a,b,c,d){var t,s,r=b-48
for(t=c.length;a<t;++a){s=c.charCodeAt(a)
if(!(s>=48&&s<=57))break
r=r*10+(s-48)}d.push(r)
return a},
R8(a,b,c,d,e){var t,s,r,q,p,o,n=b+1
for(t=c.length;n<t;++n){s=c.charCodeAt(n)
if(s===46){if(e)break
e=!0}else{if(!((((s|32)>>>0)-97&65535)<26||s===95||s===36||s===124))r=s>=48&&s<=57
else r=!0
if(!r)break}}q=c.substring(b,n)
if(e){t=a.u
p=a.e
if(p.w===9)p=p.x
o=A.Qo(t,p.x)[q]
if(o==null)A.vh('No "'+q+'" in "'+A.mD(p)+'"')
d.push(A.cE(t,p,o))}else d.push(q)
return n},
rD(a,b){var t,s=a.u,r=A.oU(a,b),q=b.pop()
if(typeof q=="string")b.push(A.Q2(s,q,r))
else{t=A.KQ(s,a.e,q)
switch(t.w){case 11:b.push(A.DS(s,t,r,a.n))
break
default:b.push(A.ap(s,t,r))
break}}},
Mt(a,b){var t,s,r,q=a.u,p=b.pop(),o=null,n=null
if(typeof p=="number")switch(p){case-1:o=b.pop()
break
case-2:n=b.pop()
break
default:b.push(p)
break}else b.push(p)
t=A.oU(a,b)
p=b.pop()
switch(p){case-3:p=b.pop()
if(o==null)o=q.sEA
if(n==null)n=q.sEA
s=A.KQ(q,a.e,p)
r=new A.ET()
r.a=t
r.b=o
r.c=n
b.push(A.Nf(q,s,r))
return
case-4:b.push(A.oP(q,b.pop(),t))
return
default:throw A.b(A.hV("Unexpected state under `()`: "+A.d(p)))}},
I3(a,b){var t=b.pop()
if(0===t){b.push(A.mZ(a.u,1,"0&"))
return}if(1===t){b.push(A.mZ(a.u,4,"1&"))
return}throw A.b(A.hV("Unexpected extended operation "+A.d(t)))},
oU(a,b){var t=b.splice(a.p)
A.cH(a.u,a.e,t)
a.p=b.pop()
return t},
KQ(a,b,c){if(typeof c=="string")return A.Q2(a,c,a.sEA)
else if(typeof c=="number"){b.toString
return A.TV(a,b,c)}else return c},
cH(a,b,c){var t,s=c.length
for(t=0;t<s;++t)c[t]=A.KQ(a,b,c[t])},
G(a,b,c){var t,s=c.length
for(t=2;t<s;t+=3)c[t]=A.KQ(a,b,c[t])},
TV(a,b,c){var t,s,r=b.w
if(r===9){if(c===0)return b.x
t=b.y
s=t.length
if(c<=s)return t[c-1]
c-=s
b=b.x
r=b.w}else if(c===0)return b
if(r!==8)throw A.b(A.hV("Indexed base must be an interface type"))
t=b.y
if(c<=t.length)return t[c-1]
throw A.b(A.hV("Bad index "+c+" for "+b["["](0)))},
t1(a,b,c){var t,s=b.d
if(s==null)s=b.d=new Map()
t=s.get(c)
if(t==null){t=A.We(a,b,null,c,null)
s.set(c,t)}return t},
We(a,b,c,d,e){var t,s,r,q,p,o,n,m,l,k,j
if(b===d)return!0
if(A.cc(d))return!0
t=b.w
if(t===4)return!0
if(A.cc(b))return!1
if(b.w===1)return!0
s=t===13
if(s)if(A.We(a,c[b.x],c,d,e))return!0
r=d.w
q=u.P
if(b===q||b===u.T){if(r===7)return A.We(a,b,c,d.x,e)
return d===q||d===u.T||r===6}if(d===u.K){if(t===7)return A.We(a,b.x,c,d,e)
return t!==6}if(t===7){if(!A.We(a,b.x,c,d,e))return!1
return A.We(a,A.xZ(a,b),c,d,e)}if(t===6)return A.We(a,q,c,d,e)&&A.We(a,b.x,c,d,e)
if(r===7){if(A.We(a,b,c,d.x,e))return!0
return A.We(a,b,c,A.xZ(a,d),e)}if(r===6)return A.We(a,b,c,q,e)||A.We(a,b,c,d.x,e)
if(s)return!1
q=t!==11
if((!q||t===12)&&d===u.Z)return!0
p=t===10
if(p&&d===u.L)return!0
if(r===12){if(b===u.g)return!0
if(t!==12)return!1
o=b.y
n=d.y
m=o.length
if(m!==n.length)return!1
c=c==null?o:o.concat(c)
e=e==null?n:n.concat(e)
for(l=0;l<m;++l){k=o[l]
j=n[l]
if(!A.We(a,k,c,j,e)||!A.We(a,j,e,k,c))return!1}return A.bO(a,b.x,c,d.x,e)}if(r===11){if(b===u.g)return!0
if(q)return!1
return A.bO(a,b,c,d,e)}if(t===8){if(r!==8)return!1
return A.pG(a,b,c,d,e)}if(p&&r===10)return A.b6(a,b,c,d,e)
return!1},
bO(a2,a3,a4,a5,a6){var t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1
if(!A.We(a2,a3.x,a4,a5.x,a6))return!1
t=a3.y
s=a5.y
r=t.a
q=s.a
p=r.length
o=q.length
if(p>o)return!1
n=o-p
m=t.b
l=s.b
k=m.length
j=l.length
if(p+k<o+j)return!1
for(i=0;i<p;++i){h=r[i]
if(!A.We(a2,q[i],a6,h,a4))return!1}for(i=0;i<n;++i){h=m[i]
if(!A.We(a2,q[p+i],a6,h,a4))return!1}for(i=0;i<j;++i){h=m[n+i]
if(!A.We(a2,l[i],a6,h,a4))return!1}g=t.c
f=s.c
e=g.length
d=f.length
for(c=0,b=0;b<d;b+=3){a=f[b]
for(;;){if(c>=e)return!1
a0=g[c]
c+=3
if(a<a0)return!1
a1=g[c-2]
if(a0<a){if(a1)return!1
continue}h=f[b+1]
if(a1&&!h)return!1
h=g[c-1]
if(!A.We(a2,f[b+2],a6,h,a4))return!1
break}}while(c<e){if(g[c+1])return!1
c+=3}return!0},
pG(a,b,c,d,e){var t,s,r,q,p,o=b.x,n=d.x
while(o!==n){t=a.tR[o]
if(t==null)return!1
if(typeof t=="string"){o=t
continue}s=t[n]
if(s==null)return!1
r=s.length
q=r>0?new Array(r):v.typeUniverse.sEA
for(p=0;p<r;++p)q[p]=A.cE(a,b,s[p])
return A.SW(a,q,null,c,d.y,e)}return A.SW(a,b.y,null,c,d.y,e)},
SW(a,b,c,d,e,f){var t,s=b.length
for(t=0;t<s;++t)if(!A.We(a,b[t],d,e[t],f))return!1
return!0},
b6(a,b,c,d,e){var t,s=b.y,r=d.y,q=s.length
if(q!==r.length)return!1
if(b.x!==d.x)return!1
for(t=0;t<q;++t)if(!A.We(a,s[t],c,r[t],e))return!1
return!0},
lR(a){var t=a.w,s=!0
if(!(a===u.P||a===u.T))if(!A.cc(a))if(t!==6)s=t===7&&A.lR(a.x)
return s},
cc(a){var t=a.w
return t===2||t===3||t===4||t===5||a===u.X},
Ix(a,b){var t,s,r=Object.keys(b),q=r.length
for(t=0;t<q;++t){s=r[t]
a[s]=b[s]}},
vU(a){return a>0?new Array(a):v.typeUniverse.sEA},
Jc:function Jc(a,b){var _=this
_.a=a
_.b=b
_.r=_.f=_.d=_.c=null
_.w=0
_.as=_.Q=_.z=_.y=_.x=null},
ET:function ET(){this.c=this.b=this.a=null},
lY:function lY(a){this.a=a},
u9:function u9(){},
iM:function iM(a){this.a=a},
ar:function ar(){},
H(a,b,c){var t=J.I(b)
if(!t.G())return a
if(c.length===0){do a+=A.d(t.gl())
while(t.G())}else{a+=A.d(t.gl())
while(t.G())a=a+c+A.d(t.gl())}return a},
p(a){if(typeof a=="number"||A.y(a)||a==null)return J.C(a)
if(typeof a=="string")return JSON.stringify(a)
return A.i(a)},
hV(a){return new A.C6(a)},
n(a){return new A.ds(a)},
o(a){return new A.UV(a)},
t(a,b,c){var t,s
if(A.k(a))return b+"..."+c
t=new A.v(b)
$.x.push(a)
try{s=t
s.a=A.H(s.a,a,", ")}finally{$.x.pop()}t.a+=c
s=t.a
return s.charCodeAt(0)==0?s:s},
Ge:function Ge(){},
C6:function C6(a){this.a=a},
E:function E(){},
AT:function AT(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
ds:function ds(a){this.a=a},
UV:function UV(a){this.a=a},
c8:function c8(){},
j:function j(){},
v:function v(a){this.a=a},
q(a){if(typeof dartPrint=="function"){dartPrint(a)
return}if(typeof console=="object"&&typeof console.log!="undefined"){console.log(a)
return}if(typeof print=="function"){print(a)
return}throw"Unable to print message: "+String(a)},
pR(a){throw A.r(new A.a("Field '"+a+"' has been assigned during initialization."),new Error())},
E2(){var t,s,r,q,p,o="{{git_info}}"
A.q("Hello!")
t=v.G
s=t.window._peanutVars
r=t.document.querySelector("#dart_version")
r.toString
r.textContent=s.toolVersion
if(J.c(s.gitInfo,o))q=o
else if(J.c(s.gitInfo,"DIRTY"))q="dirty"
else{p=t.document.createElement("a")
p.href="https://github.com/kevmoo/peanut.dart/commit/"+A.d(s.gitInfo)
p.text="kevmoo/peanut.dart@"+A.d(s.gitInfo)
q=p}t.document.querySelector("#commit_info").replaceChildren(q)}},B={}
var w=[A,J,B]
var $={}
A.FK.prototype={}
J.vB.prototype={
n(a,b){return a===b},
"["(a){return"Instance of '"+A.u(a)+"'"},
gh(a){return A.Kx(A.VU(this))}}
J.yE.prototype={
"["(a){return String(a)},
gh(a){return A.Kx(u.y)},
$iy5:1}
J.CD.prototype={
"["(a){return"null"},
$iy5:1}
J.MF.prototype={$ivm:1}
J.u0.prototype={
"["(a){return String(a)}}
J.iC.prototype={}
J.kd.prototype={}
J.c5.prototype={
"["(a){var t=a[$.K()]
if(t==null)return this.u(a)
return"JavaScript function for "+J.C(t)}}
J.rQ.prototype={
"["(a){return String(a)}}
J.Dw.prototype={
"["(a){return String(a)}}
J.jd.prototype={
"["(a){return A.t(a,"[","]")},
gk(a){return new J.m(a,a.length,A.D(a).C("m<1>"))}}
J.BC.prototype={
R(a){var t,s,r
if(!Array.isArray(a))return null
t=a.$flags|0
if((t&4)!==0)s="const, "
else if((t&2)!==0)s="unmodifiable, "
else s=(t&1)!==0?"fixed, ":""
r="Instance of '"+A.u(a)+"'"
if(s==="")return r
return r+" ("+s+"length: "+a.length+")"}}
J.Po.prototype={}
J.m.prototype={
gl(){var t=this.d
return t==null?this.$ti.c.a(t):t},
G(){var t,s=this,r=s.a,q=r.length
if(s.b!==q)throw A.b(A.l(r))
t=s.c
if(t>=q){s.d=null
return!1}s.d=r[t]
s.c=t+1
return!0}}
J.qI.prototype={
"["(a){if(a===0&&1/a<0)return"-0.0"
else return""+a},
gh(a){return A.Kx(u.H)},
$iCP:1}
J.im.prototype={
gh(a){return A.Kx(u.S)},
$iy5:1,
$iKN:1}
J.kD.prototype={
gh(a){return A.Kx(u.i)},
$iy5:1}
J.Dr.prototype={
"["(a){return a},
gh(a){return A.Kx(u.N)},
$iy5:1,
$iqU:1}
A.a.prototype={
"["(a){return"LateInitializationError: "+this.a}}
A.a7.prototype={
gl(){var t=this.d
return t==null?this.$ti.c.a(t):t},
G(){var t,s=this,r=s.a,q=r.length
if(s.b!==q)throw A.b(A.o(r))
t=s.c
if(t>=q){s.d=null
return!1}s.d=r[t]
s.c=t+1
return!0}}
A.SU.prototype={}
A.rY.prototype={}
A.L.prototype={
"["(a){var t=this.constructor,s=t==null?null:t.name
return"Closure '"+A.NQ(s==null?"unknown":s)+"'"},
gKu(){return this},
$C:"$1",
$R:1,
$D:null}
A.E1.prototype={$C:"$2",$R:2}
A.lc.prototype={}
A.zx.prototype={
"["(a){var t=this.$static_name
if(t==null)return"Closure of unknown static method"
return"Closure '"+A.NQ(t)+"'"}}
A.rT.prototype={
"["(a){return"Closure '"+this.$_name+"' of "+("Instance of '"+A.u(this.a)+"'")}}
A.Eq.prototype={
"["(a){return"RuntimeError: "+this.a}}
A.dC.prototype={
$1(a){return this.a(a)}}
A.wN.prototype={
$2(a,b){return this.a(a,b)}}
A.VX.prototype={
$1(a){return this.a(a)}}
A.WZ.prototype={
gh(a){return B.lb},
$iy5:1}
A.eH.prototype={}
A.df.prototype={
gh(a){return B.LV},
$iy5:1}
A.b0.prototype={$iXj:1}
A.Dg.prototype={}
A.DV.prototype={}
A.zU.prototype={
gh(a){return B.Vr},
$iy5:1}
A.K8.prototype={
gh(a){return B.mB},
$iy5:1}
A.xj.prototype={
gh(a){return B.x9},
$iy5:1}
A.dE.prototype={
gh(a){return B.G3},
$iy5:1}
A.Zc.prototype={
gh(a){return B.xg},
$iy5:1}
A.wf.prototype={
gh(a){return B.Ry},
$iy5:1}
A.Pq.prototype={
gh(a){return B.zo},
$iy5:1}
A.eE.prototype={
gh(a){return B.xU},
$iy5:1}
A.V6.prototype={
gh(a){return B.iY},
$iy5:1}
A.VR.prototype={}
A.vX.prototype={}
A.WB.prototype={}
A.VS.prototype={}
A.Jc.prototype={
C(a){return A.cE(v.typeUniverse,this,a)},
Kq(a){return A.v5(v.typeUniverse,this,a)}}
A.ET.prototype={}
A.lY.prototype={
"["(a){return A.F(this.a,null)}}
A.u9.prototype={
"["(a){return this.a}}
A.iM.prototype={}
A.ar.prototype={
gk(a){return new A.a7(a,a.length,A.zK(a).C("a7<ar.E>"))},
"["(a){return A.t(a,"[","]")}}
A.Ge.prototype={}
A.C6.prototype={
"["(a){var t=this.a
if(t!=null)return"Assertion failed: "+A.p(t)
return"Assertion failed"}}
A.E.prototype={}
A.AT.prototype={
gZ(){return"Invalid argument"+(!this.a?"(s)":"")},
gN(){return""},
"["(a){var t=this,s=t.c,r=s==null?"":" ("+s+")",q=t.d,p=q==null?"":": "+q,o=t.gZ()+r+p
if(!t.a)return o
return o+t.gN()+": "+A.p(t.gE())},
gE(){return this.b}}
A.ds.prototype={
"["(a){return"UnimplementedError: "+this.a}}
A.UV.prototype={
"["(a){return"Concurrent modification during iteration: "+A.p(this.a)+"."}}
A.c8.prototype={
"["(a){return"null"}}
A.j.prototype={$ij:1,
"["(a){return"Instance of '"+A.u(this)+"'"},
gh(a){return A.RW(this)},
toString(){return this["["](this)}}
A.v.prototype={
"["(a){var t=this.a
return t.charCodeAt(0)==0?t:t}};(function aliases(){var t=J.u0.prototype
t.u=t["["]})();(function inheritance(){var t=hunkHelpers.mixin,s=hunkHelpers.inherit,r=hunkHelpers.inheritMany
s(A.j,null)
r(A.j,[A.FK,J.vB,A.rY,J.m,A.Ge,A.a7,A.SU,A.L,A.Jc,A.ET,A.lY,A.ar,A.c8,A.v])
r(J.vB,[J.yE,J.CD,J.MF,J.rQ,J.Dw,J.qI,J.Dr])
r(J.MF,[J.u0,J.jd,A.WZ,A.eH])
r(J.u0,[J.iC,J.kd,J.c5])
s(J.BC,A.rY)
s(J.Po,J.jd)
r(J.qI,[J.im,J.kD])
r(A.Ge,[A.a,A.Eq,A.u9,A.C6,A.E,A.AT,A.ds,A.UV])
r(A.L,[A.E1,A.lc,A.dC,A.VX])
r(A.lc,[A.zx,A.rT])
s(A.wN,A.E1)
r(A.eH,[A.df,A.b0])
r(A.b0,[A.VR,A.WB])
s(A.vX,A.VR)
s(A.Dg,A.vX)
s(A.VS,A.WB)
s(A.DV,A.VS)
r(A.Dg,[A.zU,A.K8])
r(A.DV,[A.xj,A.dE,A.Zc,A.wf,A.Pq,A.eE,A.V6])
s(A.iM,A.u9)
t(A.VR,A.ar)
t(A.vX,A.SU)
t(A.WB,A.ar)
t(A.VS,A.SU)})()
var v={G:typeof self!="undefined"?self:globalThis,typeUniverse:{eC:new Map(),tR:{},eT:{},tPV:{},sEA:[]},mangledGlobalNames:{KN:"int",CP:"double",lf:"num",qU:"String",a2:"bool",c8:"Null",zM:"List",j:"Object",T8:"Map",vm:"JSObject"},mangledNames:{},types:[],interceptorsByTag:null,leafTags:null,arrayRti:Symbol("$ti")}
A.xb(v.typeUniverse,JSON.parse('{"iC":"u0","kd":"u0","c5":"u0","Fu":"WZ","yE":{"y5":[]},"CD":{"y5":[]},"MF":{"vm":[]},"u0":{"vm":[]},"jd":{"vm":[]},"BC":{"rY":[]},"Po":{"jd":["1"],"vm":[]},"qI":{"CP":[]},"im":{"CP":[],"KN":[],"y5":[]},"kD":{"CP":[],"y5":[]},"Dr":{"qU":[],"y5":[]},"WZ":{"vm":[],"y5":[]},"eH":{"vm":[]},"df":{"vm":[],"y5":[]},"b0":{"Xj":["1"],"vm":[]},"Dg":{"ar":["CP"],"Xj":["CP"],"vm":[]},"DV":{"ar":["KN"],"Xj":["KN"],"vm":[]},"zU":{"ar":["CP"],"Xj":["CP"],"vm":[],"y5":[],"ar.E":"CP"},"K8":{"ar":["CP"],"Xj":["CP"],"vm":[],"y5":[],"ar.E":"CP"},"xj":{"ar":["KN"],"Xj":["KN"],"vm":[],"y5":[],"ar.E":"KN"},"dE":{"ar":["KN"],"Xj":["KN"],"vm":[],"y5":[],"ar.E":"KN"},"Zc":{"ar":["KN"],"Xj":["KN"],"vm":[],"y5":[],"ar.E":"KN"},"wf":{"ar":["KN"],"Xj":["KN"],"vm":[],"y5":[],"ar.E":"KN"},"Pq":{"ar":["KN"],"Xj":["KN"],"vm":[],"y5":[],"ar.E":"KN"},"eE":{"ar":["KN"],"Xj":["KN"],"vm":[],"y5":[],"ar.E":"KN"},"V6":{"ar":["KN"],"Xj":["KN"],"vm":[],"y5":[],"ar.E":"KN"}}'))
A.FF(v.typeUniverse,JSON.parse('{"SU":1,"b0":1}'))
var u=(function rtii(){var t=A.q7
return{Z:t("EH"),s:t("jd<qU>"),b:t("jd<@>"),T:t("CD"),m:t("vm"),g:t("c5"),p:t("Xj<@>"),P:t("c8"),K:t("j"),L:t("VY"),N:t("qU"),R:t("y5"),o:t("kd"),y:t("a2"),i:t("CP"),S:t("KN"),O:t("b8<c8>?"),z:t("vm?"),X:t("j?"),v:t("qU?"),u:t("a2?"),I:t("CP?"),t:t("KN?"),n:t("lf?"),H:t("lf")}})();(function constants(){B.Ok=J.vB.prototype
B.DG=J.c5.prototype
B.Ub=J.MF.prototype
B.ZQ=J.iC.prototype
B.vB=J.kd.prototype
B.O4=function getTagFallback(o) {
  var s = Object.prototype.toString.call(o);
  return s.substring(8, s.length - 1);
}
B.Yq=function() {
  var toStringFunction = Object.prototype.toString;
  function getTag(o) {
    var s = toStringFunction.call(o);
    return s.substring(8, s.length - 1);
  }
  function getUnknownTag(object, tag) {
    if (/^HTML[A-Z].*Element$/.test(tag)) {
      var name = toStringFunction.call(object);
      if (name == "[object Object]") return null;
      return "HTMLElement";
    }
  }
  function getUnknownTagGenericBrowser(object, tag) {
    if (object instanceof HTMLElement) return "HTMLElement";
    return getUnknownTag(object, tag);
  }
  function prototypeForTag(tag) {
    if (typeof window == "undefined") return null;
    if (typeof window[tag] == "undefined") return null;
    var constructor = window[tag];
    if (typeof constructor != "function") return null;
    return constructor.prototype;
  }
  function discriminator(tag) { return null; }
  var isBrowser = typeof HTMLElement == "function";
  return {
    getTag: getTag,
    getUnknownTag: isBrowser ? getUnknownTagGenericBrowser : getUnknownTag,
    prototypeForTag: prototypeForTag,
    discriminator: discriminator };
}
B.wb=function(getTagFallback) {
  return function(hooks) {
    if (typeof navigator != "object") return hooks;
    var userAgent = navigator.userAgent;
    if (typeof userAgent != "string") return hooks;
    if (userAgent.indexOf("DumpRenderTree") >= 0) return hooks;
    if (userAgent.indexOf("Chrome") >= 0) {
      function confirm(p) {
        return typeof window == "object" && window[p] && window[p].name == p;
      }
      if (confirm("Window") && confirm("HTMLElement")) return hooks;
    }
    hooks.getTag = getTagFallback;
  };
}
B.KU=function(hooks) {
  if (typeof dartExperimentalFixupGetTag != "function") return hooks;
  hooks.getTag = dartExperimentalFixupGetTag(hooks.getTag);
}
B.dk=function(hooks) {
  if (typeof navigator != "object") return hooks;
  var userAgent = navigator.userAgent;
  if (typeof userAgent != "string") return hooks;
  if (userAgent.indexOf("Firefox") == -1) return hooks;
  var getTag = hooks.getTag;
  var quickMap = {
    "BeforeUnloadEvent": "Event",
    "DataTransfer": "Clipboard",
    "GeoGeolocation": "Geolocation",
    "Location": "!Location",
    "WorkerMessageEvent": "MessageEvent",
    "XMLDocument": "!Document"};
  function getTagFirefox(o) {
    var tag = getTag(o);
    return quickMap[tag] || tag;
  }
  hooks.getTag = getTagFirefox;
}
B.xi=function(hooks) {
  if (typeof navigator != "object") return hooks;
  var userAgent = navigator.userAgent;
  if (typeof userAgent != "string") return hooks;
  if (userAgent.indexOf("Trident/") == -1) return hooks;
  var getTag = hooks.getTag;
  var quickMap = {
    "BeforeUnloadEvent": "Event",
    "DataTransfer": "Clipboard",
    "HTMLDDElement": "HTMLElement",
    "HTMLDTElement": "HTMLElement",
    "HTMLPhraseElement": "HTMLElement",
    "Position": "Geoposition"
  };
  function getTagIE(o) {
    var tag = getTag(o);
    var newTag = quickMap[tag];
    if (newTag) return newTag;
    if (tag == "Object") {
      if (window.DataView && (o instanceof window.DataView)) return "DataView";
    }
    return tag;
  }
  function prototypeForTagIE(tag) {
    var constructor = window[tag];
    if (constructor == null) return null;
    return constructor.prototype;
  }
  hooks.getTag = getTagIE;
  hooks.prototypeForTag = prototypeForTagIE;
}
B.fQ=function(hooks) {
  var getTag = hooks.getTag;
  var prototypeForTag = hooks.prototypeForTag;
  function getTagFixed(o) {
    var tag = getTag(o);
    if (tag == "Document") {
      if (!!o.xmlVersion) return "!Document";
      return "!HTMLDocument";
    }
    return tag;
  }
  function prototypeForTagFixed(tag) {
    if (tag == "Document") return null;
    return prototypeForTag(tag);
  }
  hooks.getTag = getTagFixed;
  hooks.prototypeForTag = prototypeForTagFixed;
}
B.i7=function(hooks) { return hooks; }

B.lb=A.xq("I2")
B.LV=A.xq("Wy")
B.Vr=A.xq("oI")
B.mB=A.xq("mJ")
B.x9=A.xq("rF")
B.G3=A.xq("X6")
B.xg=A.xq("ZX")
B.Ry=A.xq("yc")
B.zo=A.xq("Pz")
B.xU=A.xq("zt")
B.iY=A.xq("n6")})();(function staticFields(){$.z=null
$.x=A.QI([],A.q7("jd<j>"))
$.i0=null
$.Al=null
$.NF=null
$.TX=null
$.x7=null
$.nw=null
$.vv=null
$.B=null})();(function lazyInitializers(){var t=hunkHelpers.lazyFinal
t($,"fa","K",()=>A.e("_$dart_dartClosure"))
t($,"hJ","M",()=>A.QI([new J.BC()],A.q7("jd<rY>")))})();(function nativeSupport(){!function(){var t=function(a){var n={}
n[a]=1
return Object.keys(hunkHelpers.convertToFastObject(n))[0]}
v.getIsolateTag=function(a){return t("___dart_"+a+v.isolateTag)}
var s="___dart_isolate_tags_"
var r=Object[s]||(Object[s]=Object.create(null))
var q="_ZxYxX"
for(var p=0;;p++){var o=t(q+"_"+p+"_")
if(!(o in r)){r[o]=1
v.isolateTag=o
break}}v.dispatchPropertyName=v.getIsolateTag("dispatch_record")}()
hunkHelpers.setOrUpdateInterceptorsByTag({ArrayBuffer:A.WZ,SharedArrayBuffer:A.WZ,ArrayBufferView:A.eH,DataView:A.df,Float32Array:A.zU,Float64Array:A.K8,Int16Array:A.xj,Int32Array:A.dE,Int8Array:A.Zc,Uint16Array:A.wf,Uint32Array:A.Pq,Uint8ClampedArray:A.eE,CanvasPixelArray:A.eE,Uint8Array:A.V6})
hunkHelpers.setOrUpdateLeafTags({ArrayBuffer:true,SharedArrayBuffer:true,ArrayBufferView:false,DataView:true,Float32Array:true,Float64Array:true,Int16Array:true,Int32Array:true,Int8Array:true,Uint16Array:true,Uint32Array:true,Uint8ClampedArray:true,CanvasPixelArray:true,Uint8Array:false})
A.b0.$nativeSuperclassTag="ArrayBufferView"
A.VR.$nativeSuperclassTag="ArrayBufferView"
A.vX.$nativeSuperclassTag="ArrayBufferView"
A.Dg.$nativeSuperclassTag="ArrayBufferView"
A.WB.$nativeSuperclassTag="ArrayBufferView"
A.VS.$nativeSuperclassTag="ArrayBufferView"
A.DV.$nativeSuperclassTag="ArrayBufferView"})()
Function.prototype.$1=function(a){return this(a)}
Function.prototype.$0=function(){return this()}
Function.prototype.$2=function(a,b){return this(a,b)}
convertAllToFastObject(w)
convertToFastObject($);(function(a){if(typeof document==="undefined"){a(null)
return}if(typeof document.currentScript!="undefined"){a(document.currentScript)
return}var t=document.scripts
function onLoad(b){for(var r=0;r<t.length;++r){t[r].removeEventListener("load",onLoad,false)}a(b.target)}for(var s=0;s<t.length;++s){t[s].addEventListener("load",onLoad,false)}})(function(a){v.currentScript=a
var t=A.E2
if(typeof dartMainRunner==="function"){dartMainRunner(t,[])}else{t([])}})})()