prong_length = 1.8;
prong_radius = 1;
center_radius = 2.3;

module torus(r1, r2) {
    rotate_extrude()
    translate(r2)
    circle(r1);
}

module male_coupler() {
    // Prongs
    intersection() {
        for (theta = [0:120:360])
        rotate(theta) {
            rotate([-90,0,90])
            cylinder(r=prong_radius, h=prong_length+center_radius, $fn=20);
        }

        translate([0,0,-prong_radius])
        cylinder(h=2*prong_radius, r=prong_length+center_radius, $fn=60);
    }

    // Clip
    difference() {
        translate([0,0,-1.5])
        union() {
            cylinder(r=center_radius, h=12, $fn=30);

            translate([0,0,12])
            scale([1,1,0.7])
            sphere(r=center_radius, $fn=40);
        }

        translate([0,0,8])
        rotate([0,90,0])
        scale([1.5,1,1])
        cylinder(r=1, h=10, center=true, $fn=20);

    }
}

module female_coupler() {
    sub_scale = 1.1; //
    catch_depth = 1;
    difference() {
        translate([0,0,-1.5])
        cylinder(r=1+sub_scale*(prong_length+center_radius), h=4*prong_radius+2.5, $fn=40);

        // Subtract out stem
        mirror([0,1,0])
        translate([0,0,-1])
        cylinder(r=sub_scale*center_radius, h=30, $fn=40);

        // Cut out prong entrance
        intersection() {
            for (theta = [0:120:360])
            rotate(theta)
            translate([-2.2*prong_radius/2, 0, 0])
            cube([2.2*prong_radius, sub_scale*(prong_length+center_radius), 10]);

            cylinder(h=10, r=sub_scale*(prong_length+center_radius), $fn=80);
        }

        // Catches
        translate([0,0,2.5*prong_radius])
        for (theta = [0:120:360])
        rotate(theta) {
            translate([0,0,1])
            rotate([90,0,0])
            cylinder(r=1.1*prong_radius, h=center_radius+prong_length, $fn=30);

            mirror([0,-1,0])
            translate([0, (center_radius+prong_length)/2, -prong_radius/2])
            cube([1.1*2*prong_radius, center_radius+prong_length, 4], center=true);
        }

        // Cut out passage for prongs
        difference() {
            cylinder(h=2.5*prong_radius, r=sub_scale*(prong_length+center_radius), $fn=80);

            // Stops
            for (theta = [-20:120:360])
            rotate(theta) {
                translate()
                cube([2, sub_scale*(center_radius+prong_length), 2.5*prong_radius]);
            }
        }
    }
}

module female_coupler_with_clip() {
    intersection() {
        female_coupler();
        translate([0,0,-4]) sphere(r=10, $fn=40);
    }

    // Clip
    translate([0,0,-1.5])
    mirror([0,0,-1])
    difference() {
        sphere(r=5.5, h=5, $fn=40);

        translate([0,0,-10])
        cube([20,20,20], center=true);

        translate([0,0,2])
        rotate([0,90,0])
        scale([1,2,1])
        cylinder(r=3/2, h=20, center=true, $fn=20);
    }
}

module plate() {
    translate([0,0,1.5]) male_coupler();

    translate([10,0,5])
    rotate([0,180,0]) female_coupler_with_clip();
}

// Fit test
//translate([0,0,-1]) female_coupler();
//rotate(30) male_coupler();

// Print plate
scale(2.0) plate();

// 1 inch reference object for scale
//translate([10, 10, 0]) cube([25.4, 25.4, 25.4]);