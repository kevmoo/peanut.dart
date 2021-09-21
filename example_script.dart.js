(function dartProgram(){function copyProperties(a,b){var u=Object.keys(a)
for(var t=0;t<u.length;t++){var s=u[t]
b[s]=a[s]}}function mixinProperties(a,b){var u=Object.keys(a)
for(var t=0;t<u.length;t++){var s=u[t]
if(!b.hasOwnProperty(s))b[s]=a[s]}}var z=function(){var u=function(){}
u.prototype={p:{}}
var t=new u()
if(!(t.__proto__&&t.__proto__.p===u.prototype.p))return false
try{if(typeof navigator!="undefined"&&typeof navigator.userAgent=="string"&&navigator.userAgent.indexOf("Chrome/")>=0)return true
if(typeof version=="function"&&version.length==0){var s=version()
if(/^\d+\.\d+\.\d+\.\d+$/.test(s))return true}}catch(r){}return false}()
function setFunctionNamesIfNecessary(a){function t(){};if(typeof t.name=="string")return
for(var u=0;u<a.length;u++){var t=a[u]
var s=Object.keys(t)
for(var r=0;r<s.length;r++){var q=s[r]
var p=t[q]
if(typeof p=="function")p.name=q}}}function inherit(a,b){a.prototype.constructor=a
a.prototype["$i"+a.name]=a
if(b!=null){if(z){a.prototype.__proto__=b.prototype
return}var u=Object.create(b.prototype)
copyProperties(a.prototype,u)
a.prototype=u}}function inheritMany(a,b){for(var u=0;u<b.length;u++)inherit(b[u],a)}function mixin(a,b){mixinProperties(b.prototype,a.prototype)
a.prototype.constructor=a}function lazyOld(a,b,c,d){var u=a
a[b]=u
a[c]=function(){a[c]=function(){A.e(b)}
var t
var s=d
try{if(a[b]===u){t=a[b]=s
t=a[b]=d()}else t=a[b]}finally{if(t===s)a[b]=null
a[c]=function(){return this[b]}}return t}}function lazy(a,b,c,d){var u=a
a[b]=u
a[c]=function(){if(a[b]===u)a[b]=d()
a[c]=function(){return this[b]}
return a[b]}}function lazyFinal(a,b,c,d){var u=a
a[b]=u
a[c]=function(){if(a[b]===u){var t=d()
if(a[b]!==u)A.p(b)
a[b]=t}a[c]=function(){return this[b]}
return a[b]}}function makeConstList(a){a.immutable$list=Array
a.fixed$length=Array
return a}function convertToFastObject(a){function t(){}t.prototype=a
new t()
return a}function convertAllToFastObject(a){for(var u=0;u<a.length;++u)convertToFastObject(a[u])}var y=0
function instanceTearOffGetter(a,b){var u=b.fs[0]
if(a)return new Function("parameters, createTearOffClass, cache","return function tearOff_"+u+y+++"(receiver) {"+"if (cache === null) cache = createTearOffClass(parameters);"+"return new cache(receiver, this);"+"}")(b,A.K,null)
else return new Function("parameters, createTearOffClass, cache","return function tearOff_"+u+y+++"() {"+"if (cache === null) cache = createTearOffClass(parameters);"+"return new cache(this, null);"+"}")(b,A.K,null)}function staticTearOffGetter(a){var u=null
return function(){if(u===null)u=A.K(a).prototype
return u}}var x=0
function tearOffParameters(a,b,c,d,e,f,g,h,i,j){if(typeof h=="number")h+=x
return{co:a,iS:b,iI:c,rC:d,dV:e,cs:f,fs:g,fT:h,aI:i||0,nDA:j}}function installStaticTearOff(a,b,c,d,e,f,g,h){var u=tearOffParameters(a,true,false,c,d,e,f,g,h,false)
var t=staticTearOffGetter(u)
a[b]=t}function installInstanceTearOff(a,b,c,d,e,f,g,h,i,j){c=!!c
var u=tearOffParameters(a,false,c,d,e,f,g,h,i,!!j)
var t=instanceTearOffGetter(c,u)
a[b]=t}function setOrUpdateInterceptorsByTag(a){var u=v.interceptorsByTag
if(!u){v.interceptorsByTag=a
return}copyProperties(a,u)}function setOrUpdateLeafTags(a){var u=v.leafTags
if(!u){v.leafTags=a
return}copyProperties(a,u)}function updateTypes(a){var u=v.types
var t=u.length
u.push.apply(u,a)
return t}function updateHolder(a,b){copyProperties(b,a)
return a}var hunkHelpers=function(){var u=function(a,b,c,d,e){return function(f,g,h,i){return installInstanceTearOff(f,g,a,b,c,d,[h],i,e,false)}},t=function(a,b,c,d){return function(e,f,g,h){return installStaticTearOff(e,f,a,b,c,[g],h,d)}}
return{inherit:inherit,inheritMany:inheritMany,mixin:mixin,installStaticTearOff:installStaticTearOff,installInstanceTearOff:installInstanceTearOff,_instance_0u:u(0,0,null,["$0"],0),_instance_1u:u(0,1,null,["$1"],0),_instance_2u:u(0,2,null,["$2"],0),_instance_0i:u(1,0,null,["$0"],0),_instance_1i:u(1,1,null,["$1"],0),_instance_2i:u(1,2,null,["$2"],0),_static_0:t(0,null,["$0"],0),_static_1:t(1,null,["$1"],0),_static_2:t(2,null,["$2"],0),makeConstList:makeConstList,lazy:lazy,lazyFinal:lazyFinal,lazyOld:lazyOld,updateHolder:updateHolder,convertToFastObject:convertToFastObject,setFunctionNamesIfNecessary:setFunctionNamesIfNecessary,updateTypes:updateTypes,setOrUpdateInterceptorsByTag:setOrUpdateInterceptorsByTag,setOrUpdateLeafTags:setOrUpdateLeafTags}}()
function initializeDeferredHunk(a){x=v.types.length
a(hunkHelpers,v,w,$)}var A={c:function c(){},a:function a(){},
q(a){if(typeof dartPrint=="function"){dartPrint(a)
return}if(typeof console=="object"&&typeof console.log!="undefined"){console.log(a)
return}if(typeof window=="object")return
if(typeof print=="function"){print(a)
return}throw"Unable to print message: "+String(a)},
x(a,b){return A.I(a.tR,b)},
F(a,b){return A.I(a.eT,b)},
I(a,b){var u,t,s=Object.keys(b),r=s.length
for(u=0;u<r;++u){t=s[u]
a[t]=b[t]}},
E(){A.q("Hello!")
return null}}
var w=[A]
hunkHelpers.setFunctionNamesIfNecessary(w)
var $={}
A.c.prototype={}
A.a.prototype={$ia:1,
toString(){return this.Z(this)}};(function inheritance(){var u=hunkHelpers.inherit
u(A.a,null)
u(A.c,A.a)})()
var v={typeUniverse:{eC:new Map(),tR:{},eT:{},tPV:{},sEA:[]},mangledGlobalNames:{B:"int",C:"double",l:"num",j:"String",M:"bool",c:"Null",z:"List"},mangledNames:{},types:[],arrayRti:Symbol("$ti")}
A.x(v.typeUniverse,JSON.parse("{}"));(function nativeSupport(){hunkHelpers.setOrUpdateInterceptorsByTag({})
hunkHelpers.setOrUpdateLeafTags({})})()
convertAllToFastObject(w)
convertToFastObject($);(function(a){if(typeof document==="undefined"){a(null)
return}if(typeof document.currentScript!="undefined"){a(document.currentScript)
return}var u=document.scripts
function onLoad(b){for(var s=0;s<u.length;++s)u[s].removeEventListener("load",onLoad,false)
a(b.target)}for(var t=0;t<u.length;++t)u[t].addEventListener("load",onLoad,false)})(function(a){v.currentScript=a
var u=A.E
if(typeof dartMainRunner==="function")dartMainRunner(u,[])
else u([])})})()