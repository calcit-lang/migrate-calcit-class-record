import assert from 'node:assert/strict';
import {execFileSync} from 'node:child_process';
import {mkdirSync,readFileSync,writeFileSync} from 'node:fs';
const run=(...args)=>execFileSync(process.env.RECORD_QUERY_CLI||'calcit',args,{encoding:'utf8',maxBuffer:20*1024*1024,stdio:['ignore','pipe','ignore']});
const q=(...args)=>JSON.parse(run('query',...args,'--format','json')).data;
mkdirSync('acceptance',{recursive:true});
function inventory(){
  const ds=[];
  for(const ns of q('ns').namespaces){
    const names=run('query','defs',ns).split('\n').filter(l=>/^  \S/.test(l)).map(l=>l.trim().split(' ')[0]);
    assert.equal(names.length,q('ns',ns).definition_count);
    for(const n of names)ds.push(q('def',`${ns}/${n}`));
  }
  assert.equal(ds.length,33);assert.equal(ds.reduce((n,d)=>n+d.tests.length,0),1);
  assert.equal(q('ns').namespaces.length,7);return ds;
}
if(process.argv[2]==='inventory'){
  const ds=inventory();writeFileSync('acceptance/reviewed.json',JSON.stringify(ds,null,2));
  console.log(JSON.stringify({definitions:ds.length,tests:ds.reduce((n,d)=>n+d.tests.length,0),namespaces:q('ns').namespaces}));
  process.exit(0);
}
assert.equal(run('-v').trim(),'0.30.1');run('docs','agents','--contract');
const config=q('config'),before=inventory();
assert.deepEqual(before,JSON.parse(readFileSync('acceptance/reviewed.json','utf8')));
const expected=structuredClone(before),dev=expected.find(d=>d.id==='app.config/dev?'),copy=expected.find(d=>d.id==='app.comp.container/effect-copy');
assert.deepEqual(dev.code,['def','dev?',['=','|dev',['option:unwrap-or',['get-env','|mode'],'|release']]]);
dev.code[2][2][0]='.unwrap-or';
let changed=0;
function walk(n){
  if(!Array.isArray(n))return n;
  if(n[0]==='count'){assert.deepEqual(n,['count','text']);changed++;return ['.len','text'];}
  return n.map(walk);
}
copy.code=walk(copy.code);assert.equal(changed,1);
const operations=expected.filter((d,i)=>JSON.stringify(d.code)!==JSON.stringify(before[i].code)).map(d=>['edit','def',d.id,'--overwrite','--input-format','json-ast','--code',JSON.stringify(d.code)]);
assert.equal(operations.length,2);
writeFileSync('acceptance/before.json',JSON.stringify(before,null,2));
writeFileSync('acceptance/operations.json',JSON.stringify(operations,null,2));
const args=['edit','transaction','--file','acceptance/operations.json','--format','json'];
const preview=JSON.parse(run(...args,'--dry-run'));assert.ok(preview.scoped_revision);
writeFileSync('acceptance/preview.json',JSON.stringify(preview,null,2));
writeFileSync('acceptance/applied.json',run(...args,'--expect-revision',preview.scoped_revision));
assert.deepEqual(inventory(),expected,'Whole definitions preserved except reviewed Option/String heads;conversion/schema/FFI/tests/HUD/startup/storage unchanged');
assert.deepEqual(q('config'),config);
writeFileSync('acceptance/after.json',JSON.stringify(expected,null,2));
writeFileSync('acceptance/snapshot-blob.txt',execFileSync('git',['hash-object','calcit.cirru'],{encoding:'utf8'}));
