bolt_diameter=3.2;
nut_diameter=5.75;
nut_corner_diameter=nutcornerdiameter(nut_diameter);
nut_thickness=3;
face_thickness=0.8;
face_width=3;
notch_diameter=3.5;
notch_separation=30;
driver_depth=5;
driver_width=36;
driver_height=14;
pivot_radius=1;
nut_padding_inner=-1;
nut_padding_outer=0.6;
nut_separation=driver_width+nut_corner_diameter+2*nut_padding_inner;

union()
{
	difference()
	{
		union()
		{
			translate([0, -driver_height/2, 0]) cube([face_width+notch_diameter/2+(driver_width-notch_separation)/2+nut_padding_inner+nut_corner_diameter+nut_padding_outer,driver_height,face_thickness], center=false);
			translate([notch_diameter/2+face_width, 0, face_thickness]) notch(radius=notch_diameter/2, length=(driver_width-notch_separation)/2, height = driver_depth-pivot_radius);
			translate([face_width+notch_diameter/2+(driver_width-notch_separation)/2, -driver_height/2, face_thickness]) cube([nut_padding_inner+nut_corner_diameter+nut_padding_outer, driver_height, driver_depth-pivot_radius]);
			translate([face_width+notch_diameter/2+(driver_width-notch_separation)/2+nut_padding_inner+nut_corner_diameter+nut_padding_outer-pivot_radius,driver_height/2,face_thickness+driver_depth-pivot_radius]) rotate([90,0,0]) cylinder(r=pivot_radius, h=driver_height, $fn=20);
		
		}
		translate([(nut_separation)/2+(notch_diameter-notch_separation)/2+face_width, 0, -1]) nut(d=nut_diameter, h=nut_thickness+1, horizontal=true);
		translate([(nut_separation)/2+(notch_diameter-notch_separation)/2+face_width, 0, -1]) polyhole(d=bolt_diameter, h=face_thickness+driver_depth+2);
	}
	translate([face_width+notch_diameter/2+(driver_width-notch_separation)/2, -driver_height/2, nut_thickness]) cube([(nut_separation+nut_corner_diameter+nut_padding_inner+nut_padding_outer-driver_width)/2, driver_height, 0.4]);
}

module notch(radius, length, height)
{
	union()
	{
		translate([0,0,height/2]) cylinder(r=radius, h=height, center=true, $fn=20);
		translate([length/2, 0, height/2]) cube([length, radius*2, height], center=true);
	}
}

module nut( d, h, horizontal = true )
{
	cornerradius = nutcornerdiameter(d)/2;
	cylinder( h = h, r = cornerradius, $fn = 6 );
	if( horizontal )
	{
		for( i = [1 : 6] )
		{
			rotate( [0, 0, 60 * i] ) translate( [-cornerradius - 0.2, 0, 0] ) rotate( [0, 0, -45] ) cube( size = [2, 2, h] );
		}
	}
}

// By nophead
module polyhole( d, h ) 
{
	n = max( round( 2 * d ), 3 );
	rotate( [0, 0, 180] ) cylinder( h = h, r = ( d / 2 ) / cos( 180 / n ), $fn = n );
}

module roundcorner( diameter )
{
	difference()
	{
		cube( size = [diameter, diameter, 99], center = false );
		translate( v = [diameter, diameter, 0] ) cylinder( h = 100, r = diameter, center = true );
	}
}

function nutcornerdiameter(d) = ( d ) / cos( 180 / 6 );