// Select the board
include <boards_dimensions/boards.scad>

module hole_trapezium(height){
    linear_extrude(height = height){
        polygon(points=[[-3,hole_heigth],[-2.4, 0],[2.4, 0],[3,hole_heigth]]);
    }
}

module pin_trapezium(height){
    linear_extrude(height = height){
        polygon(points=[[-3 + space_between_hole_pin, hole_heigth - space_between_hole_pin],[-2.4 + space_between_hole_pin, 0],[2.4 - space_between_hole_pin, 0],[3 - space_between_hole_pin, hole_heigth - space_between_hole_pin]]);
    }
}

module test_extruder(){
    translate([60, 0, 0])
        cube([10000, 10000, 500]);

    translate([-10, 10, 0])
        cube([10000, 10000, 500]);

    translate([-10, 0, 0])
        cube([10000, 10000, 37]);

    // translate([-10, 0, 9])
    //     cube([10000, 10000, 10000]);
}

module support_without_screws() {
    distance_major_hole = 0.8*wall_thickness_external;
    distance_minor_hole = (wall_thickness_external - pin_width - 2*space_between_hole_pin)/2;

    // External box
    difference() {
        cube([external_length, external_width, total_height]);

        // Internal box
        translate([start_inside_cube_x, start_inside_cube_y, base_thickness])
            cube([internal_length, internal_width, total_height - base_thickness]);

        // Remove left wall
        translate([0, wall_thickness_external, base_thickness])
            cube([external_length, start_inside_cube_y - wall_thickness_external - wall_thickness_internal, total_height - base_thickness]);

        // Remove right wall
        translate([0, start_inside_cube_y + internal_width + wall_thickness_internal, base_thickness])
            cube([external_length, external_width - start_inside_cube_y - internal_width - wall_thickness_external - wall_thickness_internal, total_height - base_thickness]);

        // Remove back wall, including floor
        translate([0, wall_thickness_external, base_thickness])
            cube([start_inside_cube_x - wall_thickness_internal, external_width - 2*wall_thickness_external, total_height - base_thickness]);

        // Remove back wall, mantaining floor
        translate([0, wall_thickness_external, 0])
            cube([start_inside_cube_x - 2*wall_thickness_internal, external_width - 2*wall_thickness_external, total_height]);

        // Remove front wall, including floor
        translate([external_width - start_inside_cube_x + wall_thickness_internal, wall_thickness_external, base_thickness])
            cube([start_inside_cube_x - wall_thickness_internal, external_width - 2*wall_thickness_external, total_height - base_thickness]);

        // Remove front wall, mantaining floor
        translate([external_width - start_inside_cube_x + 2*wall_thickness_internal, wall_thickness_external, 0])
            cube([start_inside_cube_x - 2*wall_thickness_internal, external_width - 2*wall_thickness_external, total_height]);

        // Internal hole on the floor for board
        translate([start_inside_cube_x+base_size, start_inside_cube_y+base_size])
            cube([internal_length-2*base_size, internal_width-2*base_size, total_height - base_thickness]);

        // Remove front wall on internal box
        translate([start_inside_cube_x + internal_length, start_inside_cube_y + left_distance_front, base_thickness])
            cube([wall_thickness_internal, internal_width - left_distance_front - right_distance_front, total_height - base_thickness]);

        // Remove back wall on internal box
        translate([start_inside_cube_x - wall_thickness_internal, start_inside_cube_y + left_distance_back, base_thickness])
            cube([wall_thickness_internal, internal_width - left_distance_back - right_distance_back, total_height - base_thickness]);

        // Remove lateral walls on internal box
        translate([start_inside_cube_x + internal_lateral_thickness, wall_thickness_external, base_thickness])
            cube([internal_length - 2*internal_lateral_thickness, external_width -2*wall_thickness_external, total_height - base_thickness]);

        // Remove roof of internal box
        translate([0, wall_thickness_external, internal_heigth])
            cube([external_length, external_width - 2*wall_thickness_external, total_height - internal_heigth]);

        // Hole on the floor, left side
        translate([0, wall_thickness_external/2, 0]) rotate([90,0,90])
            hole_trapezium(external_length - wall_thickness_external);

        // Hole on the floor, right side
        translate([0, external_width - wall_thickness_external/2, 0]) rotate([90,0,90])
            hole_trapezium(external_length - wall_thickness_external);

        square_size = 70.5;
        space_between = 10;

        // First square hole on left side
        translate([0.5*space_between, 0, 1.35*base_thickness])
            cube([square_size, wall_thickness_external, total_height - 1/2*wall_thickness_external - 1.35*base_thickness]);

        // Second square hole on left side
        translate([1.5*space_between + square_size, 0, 1.35*base_thickness])
            cube([square_size, wall_thickness_external, total_height - 1/2*wall_thickness_external - 1.35*base_thickness]);

        // First square hole on right side
        translate([0.5*space_between, external_width - wall_thickness_external, 1.35*base_thickness])
            cube([square_size, wall_thickness_external, total_height - 1/2*wall_thickness_external - 1.35*base_thickness]);

        // Second square hole on right side
        translate([1.5*space_between + square_size, external_width - wall_thickness_external, 1.35*base_thickness])
            cube([square_size, wall_thickness_external, total_height - 1/2*wall_thickness_external - 1.35*base_thickness]);
    }

    // Pin on roof, left side
    translate([0, wall_thickness_external/2, total_height]) rotate([90,0,90])
        pin_trapezium(external_length - wall_thickness_external - space_between_hole_pin);

    // Pin on roof, right side
    translate([0, external_width - wall_thickness_external/2, total_height]) rotate([90,0,90])
        pin_trapezium(external_length - wall_thickness_external - space_between_hole_pin);

    // Foot back left
    translate([start_inside_cube_x, start_inside_cube_y, base_thickness])
        cube([foot_size, foot_size, foot_height]);

    // Foot back right
    translate([start_inside_cube_x, start_inside_cube_y + internal_width - foot_size, base_thickness])
        cube([foot_size, foot_size, foot_height]);

    // Foot front left
    translate([start_inside_cube_x + internal_length - foot_size, start_inside_cube_y, base_thickness])
        cube([foot_size, foot_size, foot_height]);

    // Foot front right
    translate([start_inside_cube_x + internal_length - foot_size, start_inside_cube_y + internal_width - foot_size, base_thickness])
        cube([foot_size, foot_size, foot_height]);
}

module support() {
    difference() {
        support_without_screws();

        // Screw hole, up left
        translate([start_inside_cube_x +  screw_distance_x, start_inside_cube_y +  screw_distance_y, base_thickness + foot_height - 3])  // Move slightly down to ensure a clean cut
            cylinder(h = 3, r = 1.2, $fn = 100);

        // Screw hole, down left
        translate([start_inside_cube_x + internal_length -  screw_distance_x, start_inside_cube_y +  screw_distance_y, base_thickness + foot_height - 3])  // Move slightly down to ensure a clean cut
            cylinder(h = 3, r = 1.2, $fn = 100);

        // Screw hole, up right
        translate([start_inside_cube_x +  screw_distance_x, start_inside_cube_y + internal_width -  screw_distance_y, base_thickness + foot_height - 3])  // Move slightly down to ensure a clean cut
            cylinder(h = 3, r = 1.2, $fn = 100);

        // Screw hole, down right
        translate([start_inside_cube_x + internal_length -  screw_distance_x, start_inside_cube_y + internal_width -  screw_distance_y, base_thickness + foot_height - 3])  // Move slightly down to ensure a clean cut
            cylinder(h = 3, r = 1.2, $fn = 100);

        // test_extruder();
    }
}

support();
