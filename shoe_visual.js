// Visual upgrade for the Magic Shoe: unmistakably long, pointed and tightly up-curled.
(function(){
  function enhance(){
    const shoe=window.__magicShoe, THREE=window.__MAGIC_THREE;
    if(!shoe || !THREE) return false;
    if(shoe.userData.heroToeAdded) return true;
    shoe.userData.heroToeAdded=true;

    // Remove the earlier straight-ish tube toe/ridge so the new silhouette is clean.
    for(let i=shoe.children.length-1;i>=0;i--){
      const c=shoe.children[i];
      if(c.geometry && c.geometry.type==='TubeGeometry') shoe.remove(c);
    }

    shoe.scale.setScalar(1.28);
    shoe.rotation.y=-0.18;

    const mat=(c,r=.3,m=.15,e=0)=>new THREE.MeshStandardMaterial({color:c,roughness:r,metalness:m,emissive:e,emissiveIntensity:e?1.7:0});
    const leather=mat(0x8f43bd,.24,.12,0x2a0838);
    const edge=mat(0xf3c96b,.18,.75,0x63370a);
    const glow=mat(0x7fffe9,.1,.08,0x19e2c0);

    // Signature Arabian-fantasy silhouette: very long, narrow toe, then a strong hook upward and slightly backward.
    const curve=new THREE.CatmullRomCurve3([
      new THREE.Vector3(.45,.46,0),new THREE.Vector3(1.35,.38,0),new THREE.Vector3(2.35,.40,0),
      new THREE.Vector3(3.25,.58,0),new THREE.Vector3(4.05,.98,0),new THREE.Vector3(4.55,1.60,0),
      new THREE.Vector3(4.58,2.28,0),new THREE.Vector3(4.28,2.82,0),new THREE.Vector3(3.72,3.05,0)
    ]);
    const toe=new THREE.Mesh(new THREE.TubeGeometry(curve,64,.36,16,false),leather);
    toe.castShadow=true; shoe.add(toe);

    const goldCurve=new THREE.CatmullRomCurve3([
      new THREE.Vector3(.55,.78,.02),new THREE.Vector3(1.45,.70,.02),new THREE.Vector3(2.35,.72,.02),
      new THREE.Vector3(3.25,.90,.02),new THREE.Vector3(4.03,1.30,.02),new THREE.Vector3(4.48,1.90,.02),
      new THREE.Vector3(4.50,2.50,.02),new THREE.Vector3(4.22,2.88,.02)
    ]);
    const trim=new THREE.Mesh(new THREE.TubeGeometry(goldCurve,64,.065,9,false),edge); shoe.add(trim);

    const tip=new THREE.Mesh(new THREE.OctahedronGeometry(.27),glow);
    tip.position.set(3.68,3.10,0); tip.castShadow=true; shoe.add(tip);
    const light=new THREE.PointLight(0x65ffe8,18,9); light.position.copy(tip.position); shoe.add(light);

    const tassel=new THREE.Group(); tassel.position.set(4.10,2.40,.08); shoe.add(tassel);
    const cord=new THREE.Mesh(new THREE.CylinderGeometry(.035,.035,.62,8),edge); cord.rotation.z=-.35; tassel.add(cord);
    for(let i=-3;i<=3;i++){
      const strand=new THREE.Mesh(new THREE.CylinderGeometry(.022,.038,.58,7),edge);
      strand.position.x=i*.055; strand.rotation.z=i*.07; tassel.add(strand);
    }
    return true;
  }

  // Mobile boot guard: the loading layer must never sit above the title and steal touches.
  function enableControls(){
    const loading=document.getElementById('loading');
    const title=document.getElementById('title');
    const start=document.getElementById('start');
    const action=document.getElementById('action');
    if(loading){ loading.style.display='none'; loading.style.pointerEvents='none'; }

    // Always make the start button responsive on touch screens, even if the main module
    // was delayed by WebGL initialization. The game's own handler can still run normally.
    if(start && !start.dataset.magicBound){
      start.dataset.magicBound='1';
      start.addEventListener('pointerup',function(){
        if(title) title.classList.add('hide');
      },{passive:true});
      start.addEventListener('touchend',function(){
        if(title) title.classList.add('hide');
      },{passive:true});
    }

    if(action && !action.dataset.magicBound){
      action.dataset.magicBound='1';
      action.addEventListener('pointerup',function(){
        const toast=document.getElementById('toast');
        if(toast){
          toast.textContent='اقترب من الرمز السحري واستكشف المكان';
          toast.classList.add('show');
          setTimeout(()=>toast.classList.remove('show'),1800);
        }
      },{passive:true});
    }
  }

  enableControls();
  const timer=setInterval(()=>{ if(enhance()) clearInterval(timer); },100);
  setTimeout(enableControls,250);
  setTimeout(enableControls,1000);
})();
