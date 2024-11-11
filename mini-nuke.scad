
fins=3;
mid_shoot=true;
//BT_ID=54;
//BT_OD=57.5;
BT_ID=75;
BT_OD=76.8;
//inner_tube=[75.8,74.6];
main_dia=205;

//BT_ID=3.9*25.4;
//BT_OD=4*25.4;
//=12*25.4;

MMT_ID=38;
MMT_OD=41.7;
foam_holes=false;
hollow=false;

//MMT_ID=29;
//MMT_OD=31;

mid_section=24;
wall_thickness=2;
internal_wall=1.6;
fin_thickness=6.2;
door=[80,40];
heatset=4;

include <../Rocket-Parts/RailGuide.scad>;
include <../rocket_parts/rockit.scad>;
$fn=$preview ? 30 : 360;
//$fn=$preview ? 30 : 90;
tube_length=main_dia*1.5+main_dia*1.15+mid_section;



// Show most parts of rocket.
$vpr = ([60,0,210]);
$vpt = ([0,0,90]);
$vpf = (15);
$vpd = (2000);
color("#5E6345")  mini_nuke_model();


// For printing
//mini_nuke_nose();
//mini_nuke_tail();
//mini_nuke_door_fix(); // For Rockit altimeter
//mini_nuke_door2(); // base door
//tail_ring();
//fin();

// add round over to ring
//tail_ring_aero();

// little nose weight
//top_spacer();

//450_holder(part=1);

//laser_cut_parts(fins=true, cut_38=true, cut_54=true, top_parts=true);


module top_spacer(thickness=12, solid=false, wall=0.5, center_hole=12, tnuts=8){
  difference(){
    cylinder(d=BT_ID-1.4,h=thickness,center=true);
    cylinder(d=center_hole,h=thickness+1,center=true);
    for(R=[0:360/tnuts:360]) rotate([0,0,R])
      translate([BT_OD/2-(BT_OD/2-10)/2,0,0])
        cylinder(d=6, h=thickness+1,center=true);
    if( ! solid )
    translate([0,0,wall]) difference(){
      cylinder(d=BT_ID-1.4-wall*2,h=thickness,center=true);
      cylinder(d=center_hole+wall*2,h=thickness+1,center=true);
    for(R=[0:360/tnuts:360]) rotate([0,0,R])
      translate([BT_OD/2-(BT_OD/2-10)/2,0,0])
        cylinder(d=6+wall*2, h=thickness+1,center=true);
    }
  }
}

module mini_nuke_model(){
  fin_width=main_dia/2-BT_OD/2;
  difference(){
    mini_nuke();
    if( $preview )
      translate([-200,0,0]) cube([200,200,600]);
//    translate([0,0,45]) difference(){
//      cylinder(d=main_dia, h=100);
//      cylinder(d=main_dia/2+40, h=100);
//    }
  }
  translate([0,0,15]) thrust_plate();
  for(R=[0:(360/fins):360]) rotate([0,0,R]) 
    translate([main_dia/2-fin_width/2-2,0,0]) 
      fin();
  translate([0,0,5]){
    tail_ring_aero();
    tail_ring();
  }
//  translate([0,0,tube_length/2+20]) difference(){
//    cylinder(d=BT_OD,h=tube_length,center=true);
//    cylinder(d=BT_ID,h=tube_length+1,center=true);
//  }
//  cylinder(d=38, h=175+10+10);
//  cylinder(d=38, h=25.4*11);
}



module door_support(height=door[0], ddia=12, angle=door[1], inset=6, holes=true){
  intersection(){
    difference(){
      rotate([0,0,180-door[1]/2]) translate([0,0,40-4]) door_internal(height=height+8, ddia=ddia+18, angle=angle, inset=inset);
      translate([0,0,main_dia*0.81]) mini_nuke_shape(dia=main_dia-10);
      difference(){
        rotate([0,0,180-door[1]/2]) translate([0,0,44]) 
          door_internal(height=height-8, ddia=ddia-8, angle=angle, inset=inset);
        rotate([0,0,180-door[1]/2]) translate([0,0,40])
      for(Z=[ddia/2+inset, height-ddia/2-inset], R=[0, angle])
        rotate([0,0,R]) 
          translate([0,0,Z])
            rotate([0,90,0]) 
              cylinder(d=ddia, h=main_dia);
      }
      if( holes )
      rotate([0,0,180-door[1]/2]) translate([0,0,40])
      for(Z=[ddia/2+inset, height-ddia/2-inset], R=[0, angle])
        rotate([0,0,R]) 
          translate([0,0,Z])
            rotate([0,90,0]) 
              cylinder(d=heatset, h=main_dia);
    }
    translate([0,0,main_dia*0.81]) 
      mini_nuke_shape(dia=main_dia-wall_thickness+0.1);
  }
  
  intersection(){
    difference(){
      union(){
        rotate([0,0,180-door[1]/2]) translate([0,0,40])
      for(Z=[ddia/2+inset, height-ddia/2-inset], R=[0, angle])
        rotate([0,0,R]) 
          translate([0,0,Z])
            rotate([0,90,0]) 
              difference(){
                cylinder(d=ddia, h=main_dia);
                cylinder(d=heatset, h=main_dia);
              }
    }
      translate([0,0,main_dia*0.81]) mini_nuke_shape(dia=main_dia-20);
    }
    translate([0,0,main_dia*0.81]) 
      mini_nuke_shape(dia=main_dia-wall_thickness+0.1);
  }
}

module mini_nuke_door(holes=true){
  translate([0,0,main_dia*0.91]) rotate([180,0,0]) 
  rotate([0,0,180-door[1]/2]) translate([0,0,40]) 
    door(holes=holes) translate([0,0,-40]) 
      difference(){
      mini_nuke_shape();
      mini_nuke_shape(dia=main_dia-wall_thickness);
      }
}

module mini_nuke_door2(holes=true){
  difference(){
    translate([0,0,40]) rotate([0,0,180-door[1]/2]) 
      door(height=door[0], ddia=12, angle=door[1], inset=6,         holes=holes, hole_dia=3.3) 
      translate([0,0,main_dia*0.81]) 
      translate([0,0,-40]) difference(){
        mini_nuke_shape();
        mini_nuke_shape(dia=main_dia-6);
      }
    rotate([0,0,0.5]) door_support(height=door[0], ddia=12.4, angle=door[1]-1, inset=6.4, holes=false);
  }
}

module mini_nuke_door_fix(){
  difference(){
    translate([0,0,40]) rotate([0,0,180-door[1]/2]) 
      door(height=door[0], ddia=11.5, angle=door[1], inset=6,         holes=false, hole_dia=3.3) 
      translate([0,0,main_dia*0.81]) 
        translate([0,0,-40]) mini_nuke_shape2(thickness=6);
//      translate([0,0,-40]) difference(){
//        mini_nuke_shape();
//        mini_nuke_shape(dia=main_dia-6);
//      }
      
    rotate([0,0,0.5]) door_support(height=door[0], ddia=12.4, angle=door[1]-1, inset=6.4, holes=false);
   
    translate([0,0,40]) rotate([0,0,180-door[1]/2]) 
      for(Z=[12-2, door[0]-12], R=[0, door[1]])
        rotate([0,0,R]) 
          translate([main_dia/2,0,Z])
            translate([-main_dia/2-1,0,0])
              rotate([0,90,0]) 
                cylinder(d=3.3, h=main_dia);
    translate([-main_dia/2+10,0,70]) 
      rotate([0,90,0]) cylinder(d=2,h=20);
  }
  %translate([-main_dia/2+23,0,87]) rotate([0,70,0]) battery_450();
  intersection(){
    translate([0,0,main_dia*0.81]) mini_nuke_shape2(thickness=100);
    union(){
      translate([-main_dia/2+8,0,80]) rotate([0,90,0]) 
        rockit_mount(height=25);
      translate([-main_dia/2+23,0,87]) 
        for(Y=[-1,1]) translate([0,20*Y,0])
          rotate([0,70,0]) 450_holder(part=2);
    }
  }
}


module 450_holder(part=0, width=7, cpoint=12){
  if(part==1){
    intersection(){
      450_holder_internal(width=width, cpoint=cpoint);
      translate([0,0,7]) cube([cpoint*2+width,width,7.5], center=true);
    }
  }
  else if(part==2){
    difference(){
      450_holder_internal(width=width, cpoint=cpoint);
      translate([0,0,7]) cube([cpoint*2+width,width,7.5], center=true);
    }
  }
  else{
    450_holder_internal(width=width, cpoint=cpoint);
  }
}

module 450_holder_internal(width=7, cpoint=12){
  difference(){
    hull() for(X=[-1,1]) translate([cpoint*X,0,0]) 
      cylinder(d=width, h=15, center=true);
    for(X=[-1,1]) translate([cpoint*X,0,0]){ 
      cylinder(d=3.4, h=20, center=true);
      translate([0,0,-0.3]) cylinder(d=4, h=7, center=true);
    }
    cube([18,width,7], center=true);
  }
}


module upper_centering_ring(MMT=MMT_OD, thickness=3){
  difference(){
    centering_ring(OD=MMT, thickness=thickness);
    hull(){
      translate([BT_ID/2,0,0]) cylinder(d=6,h=thickness+1,center=true);
      translate([BT_ID/2-5,0,0]) cylinder(d=6,h=thickness+1,center=true);
    }
    if( mid_shoot )
    for(Y=[0]) translate([-MMT/2-(BT_ID-MMT)/4, 4*Y, 0]) 
      cylinder(d=5,h=thickness+1,center=true);
  }
}

module lower_centering_ring(MMT=MMT_OD, thickness=3){
  difference(){
    centering_ring(OD=MMT, thickness=thickness);
    translate([MMT/2+(BT_ID-MMT)/4, 0, 0]) 
      cylinder(d=5,h=thickness+1,center=true);
  }
}


// zclip adds holes for zclip mounts
// flange allows for flange mount retainers, first arg is number of holes, second is diameter of holes.
module thrust_plate(thickness=6, MMT=MMT_OD, zclip=true, flange=[0,0]){
  difference(){
    cylinder(d=BT_OD+4.5,h=thickness,center=true);
    cylinder(d=MMT,h=thickness+1,center=true);
    for(R=[0:(360/3):360]) rotate([0,0,R])
      translate([BT_OD/2+3,0,0]) cube([6, fin_thickness, thickness+1], center=true);
//    translate([-MMT_OD/2-(BT_ID-MMT_OD)/4, 0, 0]) 
//      cylinder(d=4,h=thickness+1,center=true);
    if( zclip ){
      rotate([0,0,25]) for(X=[-1,1]) 
        translate([(MMT/2+12.5)*X,0,0])
        cylinder(d=6,h=thickness+1, center=true);
    }
    if( flange[0] > 0 ){
      off=(360/flange[0]/2);
      echo(off);
      for(R=[0:360/flange[0]:360]) rotate([0,0,off+R])
        translate([flange[1],0,0])
          cylinder(d=3,h=thickness+1, center=true);
      
    }
  }
}

module upper_plate(tnuts=8, thickness=6, center_hole=6){
  difference(){
    cylinder(d=BT_OD-0.4,h=thickness,center=true);
    cylinder(d=center_hole,h=thickness+1,center=true);
    for(R=[0:360/tnuts:360]) rotate([0,0,R])
      translate([BT_OD/2-(BT_OD/2-10)/2,0,0])
        cylinder(d=6, h=thickness+1,center=true);
  }
}

module mid_plate(tnuts=8, thickness=6, center_hole=6){
  difference(){
    cylinder(d=BT_ID,h=thickness,center=true);
    cylinder(d=center_hole,h=thickness+1,center=true);
    for(R=[0:360/tnuts:360]) rotate([0,0,R])
      translate([BT_OD/2-(BT_OD/2-10)/2,0,0])
        cylinder(d=6, h=thickness+1,center=true);
  }
}

module laser_cut_parts(fins=true, cut_38=false, cut_54=true, top_parts=true){
  translate([0,MMT_OD*2,0]) 
  if( fins ){
    translate([-MMT_OD+5,MMT_OD+5,0]) projection(cut=true) 
      rotate([90,0,0]) fin();
    translate([MMT_OD-10,MMT_OD+5,0]) projection(cut=true) 
      rotate([90,0,0]) fin();
    translate([MMT_OD*2+15,MMT_OD+5,0]) projection(cut=true) 
      rotate([90,0,0]) fin();
  }
  if( cut_38 ){
    translate([-MMT_OD,MMT_OD,0]) projection(cut=true) 
      upper_centering_ring();
    translate([-MMT_OD*3,MMT_OD,0]) projection(cut=true) 
//      mid_plate();
    translate([-MMT_OD,-MMT_OD,0]) projection(cut=true) lower_centering_ring();
    translate([MMT_OD,MMT_OD,0]) projection(cut=true) 
      thrust_plate();
    translate([MMT_OD*3,MMT_OD,0]) projection(cut=true) 
      thrust_plate(zclip=false);
  }
  
  if( cut_54 ){
    translate([MMT_OD,-MMT_OD,0]) projection(cut=true) 
      thrust_plate(MMT=57, zclip=false, flange=[6,34.75]);
    translate([-MMT_OD,-MMT_OD,0]) projection(cut=true) upper_centering_ring(MMT=57);
//    translate([-MMT_OD*5,-MMT_OD,0]) projection(cut=true) lower_centering_ring(MMT=57);
  }
  
  if( top_parts ){
//    projection() 
    translate([MMT_OD,-MMT_OD*3,-1]) projection(cut=true)  upper_plate();
    projection() 
    translate([-MMT_OD,-MMT_OD*3,0]) mid_plate();
  }
}

module centering_ring(OD=MMT_OD, thickness=3){
  difference(){
    cylinder(d=BT_ID,h=thickness,center=true);
    cylinder(d=OD,h=thickness+1,center=true);
  }
}

module mini_nuke_nose(){
  tid=5;
  difference(){
    mini_nuke(dia=main_dia);
    cylinder(d=300,h=main_dia*0.81);
    translate([-BT_ID/2,0,main_dia+40]) 
      rotate([0,90,0]) cylinder(d=tid,h=10,center=true);
    translate([-BT_ID/2,0,main_dia+40]) 
      rotate([0,90,0]) cylinder(d=tid,h=10,center=true);
    translate([-BT_OD/2-internal_wall/2-10,0,main_dia-40]) 
      cylinder(d=tid,h=10,center=true);
  }
  translate([-BT_OD/2-internal_wall/2,0,main_dia+internal_wall+30-internal_wall]) etube(id=tid,length=70-internal_wall,offset=10);
}

module etube(id=5,length=10,offset=10){
  rotate([-90,0,0]) rotate_extrude(angle=90) 
    translate([-offset,0,0]) tube_form();
  translate([-offset,0,-length]) 
    linear_extrude(length) tube_form();
}

module mini_nuke_tail(){
  intersection(){
    difference(){
      mini_nuke(dia=main_dia);
      translate([-BT_OD/2-internal_wall/2-10,0,main_dia-40]) 
        cylinder(d=5,h=10,center=true);
    }
//    cylinder(d=300,h=164.02);
    cylinder(d=300,h=main_dia*0.81);
  }
//  rotate([0,0,180-door[1]/2]) translate([0,0,40])
//  door_internal();
//  translate([0,0,40+door[0]/1]) cylinder(d=main_dia, h=0.1);
//  %rotate([0,0,180-door[1]/2]) translate([0,0,60])
//  door_internal();
//  %translate([0,0,(main_dia-20)*0.81]) mini_nuke_shape(dia=main_dia-20);
}

module mini_nuke(dia=main_dia){
  difference(){
    mini_nuke_internal(dia=main_dia);
    difference(){
      rotate([0,0,180-door[1]/2]) translate([0,0,40]) door_internal();
      door_support();
    }
  }
  
  difference(){
    for(Y=[-1,1], Z=[-1,1])
      translate([-BT_OD/2+2, (door[1]/2-10)*Y, 80+(door[0]/2-20)*Z])
        rotate([90,0,-90]) printable_tab();
    cylinder(d=BT_OD+0.2,h=main_dia*0.81);
  }
}

module mini_nuke_internal(dia=main_dia){
  fin_width=dia/2-BT_OD/2;
  hole_size=12;
  translate([0,0,dia*0.81]){
    rotate([0,0,-90]) translate([0,-0.1,0]) 
      RialGuide(TubeOD = main_dia, Length = 40, Offset = 3);
    translate([dia/2,0,0]) hull(){
      cube([1,10,40],center=true);
      translate([-20,0,0]) 
        cube([1,10,wall_thickness*2],center=true);
    }
    difference(){
      mini_nuke_shape(dia=dia);
      difference(){
        echo(str("mini_nuke length=",tube_length));
        difference(){
          mini_nuke_shape(dia=dia-wall_thickness);
          translate([0,0,-main_dia*0.81]) door_support();
        }
        translate([0,0,tube_length/2-dia*0.81-10]) 
          cylinder(d=dia,h=dia*0.15);
        translate([0,0,tube_length/2-dia*0.81-20]) 
        difference(){
          cylinder(d1=150, d2=120, h=10);
          translate([0,0,-0.5]) 
            cylinder(d1=150, d2=105, h=11);
        }
        
        difference(){
          cylinder(d=dia,h=wall_thickness*2,center=true);
          cylinder(d=BT_OD,h=wall_thickness*3,center=true);
          if( foam_holes )
          for(R=[0:(360/6):360]) rotate([0,0,R]) 
            translate([BT_OD/2+(dia-BT_OD)/4,0,0])
              cylinder(d=hole_size, h=20, center=true);
            
        }
        translate([0,0,-dia*0.81]) cylinder(d=dia+10,h=45);
        difference(){
          union(){
            cylinder(d=BT_OD+0.2+internal_wall,h=tube_length,center=true);
            for(R=[0:(360/3):360]) rotate([0,0,R])
              difference(){
                cube([internal_wall,dia,tube_length],center=true);
                if(foam_holes) for(Z=[-7:2:7])
                  translate([0,BT_OD/2+20,Z*10]) 
                    rotate([0,90,0]) cylinder(d=hole_size,h=internal_wall*2,center=true);
              }
            translate([dia/4,0,0]) cube([dia/2,internal_wall,tube_length],center=true);
//          if( hollow )
//            for(R=[0:(360/6):360]) rotate([0,0,R]) 
//            translate([BT_OD/2+(dia-BT_OD)/4,0,0])
//              cylinder(d=8, h=24, center=true);
          }
          cylinder(d=BT_OD+0.2,h=tube_length,center=true);
        }
      }
      translate([0,0,-dia*0.81]) cylinder(d=BT_OD+0.2,h=100);
      
      for(R=[0:(360/fins):360]) rotate([0,0,R])
        translate([main_dia/2-fin_width/2-2.1,0,-dia*0.81])
          fin(width=fin_thickness+0.2);
//          cube([fin_width,fin_thickness+0.2,fin_width], center=true);
      
      translate([0,0,-dia*0.81]) cylinder(d=BT_OD+5,h=BT_OD*0.246);
    }
  }
}

module mini_nuke_shape(dia=main_dia, mid_section=mid_section){
  // nose 
  translate([0,0,mid_section/2-0.2]) 
    intersection(){
    resize([dia,dia,dia*1.15]) sphere(d=dia);
    cylinder(d=dia+2,h=dia*1.6/2);
  }
  cylinder(d=dia,h=mid_section,center=true);
  // tail 
  translate([0,0,-mid_section/2+0.2]) difference(){
    resize([dia,dia,dia*1.5]) sphere(d=dia);
    cylinder(d=dia+2,h=dia*1.6/2);
  }
}
module mini_nuke_shape2(dia=main_dia, mid_section=mid_section,thickness=wall_thickness){
  rotate_extrude()
  difference(){
    base_mini_nuke_shape2(dia=main_dia, mid_section=mid_section);
    if(thickness > 0)
      base_mini_nuke_shape2(dia=main_dia-thickness, mid_section=mid_section);
    translate([0,-main_dia]) square([main_dia,main_dia*2]);
  }
}

module base_mini_nuke_shape2(dia=main_dia, mid_section=mid_section){
  translate([0,mid_section/2-0.2]) intersection(){
    resize([dia,dia*1.15]) circle(d=dia);
    translate([0,dia*1.6/4]) square([dia,dia*1.6/2],center=true);
  }
  square([dia,mid_section],center=true);
  translate([0,-mid_section/2+0.2]) intersection(){
    resize([dia,dia*1.5]) circle(d=dia);
    translate([0,-dia*1.6/4]) square([dia,dia*1.6/2],center=true);
  }
}

module fin(fin_height=35, offset=25,width=fin_thickness){
  fin_width=main_dia/2-BT_OD/2-4;
  echo("fin_width",fin_width);
  hull(){
    cube([fin_width,width,fin_height],center=true);
    translate([-fin_width/2+(fin_width-offset)/2,0,offset]) 
      cube([fin_width-offset,width,fin_height],center=true);
  }
  hull(){
    cube([fin_width/2,width,2],center=true);
    translate([fin_width/2-1,0,-offset]) 
      cube([2,width,fin_height],center=true);
  }
  translate([fin_width/2,0,-15]) 
    cube([4,width,20],center=true);
}

module tail_ring_aero(dia=main_dia, thickness=4, length=0){
    rotate_extrude()
    translate([dia/2-thickness/2,0]) hull(){
      translate([0,length]) 
      intersection(){
        circle(d=thickness);
        translate([0,thickness/4]) square([thickness,thickness/2],center=true);
      }
//      translate([length,0]) 
        square([thickness,0.1],center=true);
    }
}

module tail_ring(dia=main_dia, tail_length=60){
  difference(){
    translate([0,0,-tail_length/2]) difference(){
      cylinder(d=dia, h=tail_length,center=true);
      cylinder(d=dia-8, h=tail_length+1 ,center=true);
    };
    angle = 360/fins/4;
    echo("angle",angle);
    translate([0,0,-tail_length/2-6])
      for(R=[360/fins/2:(360/fins):360]) rotate([0,0,R]){
        hull() for(Z=[-1,1]){
          rotate([0,90,angle*Z]) translate([0,0,dia/4]) cylinder(d=12,h=dia/2);
          translate([0,0,-tail_length/2]) rotate([0,90,(angle+2)*Z]) translate([0,0,dia/4]) cylinder(d=12,h=dia/2);
        }
    }
    for(R=[0:(360/fins):360]) rotate([0,0,R])
      translate([dia/2-4+0.2,0,-tail_length/2+10]) 
        cube([4,fin_thickness+0.2,20+0.2],center=true);
    
  }
  translate([-0.1,0,-tail_length/2]) rotate([0,0,-90]) RialGuide(TubeOD = dia, Length = 40, Offset = 3);
  
  for(R=[0:(360/fins):360]) rotate([0,0,R])
    translate([dia/2-4,0,-tail_length/2]) 
    difference(){
      hull(){
        translate([-5,0,tail_length/4-tail_length*0.125]) 
          cube([10,fin_thickness*2,tail_length/2],center=true);
        translate([0,0,tail_length*0.125])
        cube([1,20,tail_length*0.75],center=true);
      }
      translate([-5,0,0]) 
        cube([11,fin_thickness+0.2,tail_length+1],center=true);
    }
}

module door(height=door[0], ddia=12, angle=door[1], inset=6, holes=true,hole_dia=3.3){
  intersection(){
    difference(){
      children();
      if( holes )
        for(Z=[ddia/2+inset, height-ddia/2-inset], R=[0, angle])
          rotate([0,0,R]) 
            translate([main_dia/2,0,Z]){
              translate([-main_dia/2-1,0,0])
                rotate([0,90,0]) 
                  cylinder(d=hole_dia, h=main_dia);
              translate([-0.5,0,0])
                rotate([0,90,0]) 
                  cylinder(d=7, h=wall_thickness*8);
            }
    }
    door_internal(height=height, ddia=ddia, angle=angle, inset=inset);
  }
}

module door_internal(height=door[0], ddia=12, angle=door[1], inset=6){
  difference(){
    hull()
      for(Z=[ddia/2+inset, height-ddia/2-inset], R=[0, angle])
        rotate([0,0,R]) 
          translate([0,0,Z])
            rotate([0,90,0]) 
              cylinder(d=ddia, h=main_dia);
      cylinder(d=BT_OD+internal_wall+1, h=height);
  }
  
}

module printable_tab(d=10,l=8){
  difference(){
    hull(){
      cylinder(d=d, h=l);
      translate([0,l,0]) cube([d,l,0.1], center=true);
    }
    translate([0,0,-1]) cylinder(d=heatset, h=l+2);
  }
}

module tube_form(id=5,thickness=2){
  difference(){
    circle(d=id+thickness);
    circle(d=id);
  }
}


