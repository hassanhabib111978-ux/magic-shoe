// Visual upgrade for the Magic Shoe: a clearly pointed, dramatically up-curled Arabian-fantasy toe.
(function(){
  function enhance(){
    const shoe=window.__magicShoe, THREE=window.__MAGIC_THREE;
    if(!shoe || !THREE) return false;
    if(shoe.userData.heroToeAdded) return true;
    shoe.userData.heroToeAdded=true;
    shoe.scale.setScalar(1.18);
    shoe.rotation.y=-0.22;

    const mat=(c,r=.3,m=.15,e=0)=>new THREE.MeshStandardMaterial({color:c,roughness:r,metalness:m,emissive:e,emissiveIntensity:e?1.7:0});
    const leather=mat(0x8f43bd,.24,.12,0x2a0838);
    const edge=mat(0xf3c96b,.18,.75,0x63370a);
    const glow=mat(0x7fffe9,.1,.08,0x19e2c0);

    // A long, unmistakable curled toe: low at the vamp, then rising sharply.
    const curve=new THREE.CatmullRomCurve3([
      new THREE.Vector3(.55,.50,0),
      new THREE.Vector3(1.55,.43,0),
      new THREE.Vector3(2.55,.50,0),
      new THREE.Vector3(3.45,.86,0),
      new THREE.Vector3(4.10,1.55,0),
      new THREE.Vector3(4.16,2.25,0),
      new THREE.Vector3(3.82,2.62,0)
    ]);
    const toe=new THREE.Mesh(new THREE.TubeGeometry(curve,48,.43,16,false),leather);
    toe.castShadow=true; shoe.add(toe);

    const goldCurve=new THREE.CatmullRomCurve3([
      new THREE.Vector3(.65,.82,.02),new THREE.Vector3(1.6,.76,.02),
      new THREE.Vector3(2.55,.84,.02),new THREE.Vector3(3.42,1.18,.02),
      new THREE.Vector3(4.0,1.82,.02),new THREE.Vector3(4.04,2.42,.02)
    ]);
    const trim=new THREE.Mesh(new THREE.TubeGeometry(goldCurve,48,.075,9,false),edge); shoe.add(trim);

    // Small jewel at the curled tip makes the toe read as magical rather than ordinary footwear.
    const tip=new THREE.Mesh(new THREE.OctahedronGeometry(.24),glow);
    tip.position.set(3.80,2.68,0); tip.castShadow=true; shoe.add(tip);
    const light=new THREE.PointLight(0x65ffe8,14,7); light.position.copy(tip.position); shoe.add(light);

    // Decorative tassel beneath the curl.
    const tassel=new THREE.Group(); tassel.position.set(3.72,2.15,.08); shoe.add(tassel);
    const cord=new THREE.Mesh(new THREE.CylinderGeometry(.035,.035,.55,8),edge); cord.rotation.z=-.45; tassel.add(cord);
    for(let i=-2;i<=2;i++){
      const strand=new THREE.Mesh(new THREE.CylinderGeometry(.025,.04,.52,7),edge);
      strand.position.x=i*.055; strand.rotation.z=i*.09; tassel.add(strand);
    }
    return true;
  }
  const timer=setInterval(()=>{ if(enhance()) clearInterval(timer); },100);
})();
