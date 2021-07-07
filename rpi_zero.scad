// A SCAD of the Raspberry pi zero with headers.

//*
$fa=0.5; // default minimum facet angle is now 0.5
$fs=0.5; // default minimum facet size is now 0.5 mm
/*/
// set to higher for faster rendering during design
$fa=1;
$fs=1.5;
//*/

module draw_resistor(res_width, res_height, res_depth, res_color, solder_t=0.05, silver=[0.7529, 0.7529, 0.7529]) {
    // The Resistor
    color(res_color)
        translate([0, 0, solder_t/2])
            cube([res_width, res_depth, res_height-pi0_thickness]);

    color(silver) {
        // Solder point 1
        translate([-solder_t/2, -solder_t/2, 0])
            cube([res_width+solder_t, res_depth/4+solder_t, res_height+solder_t-pi0_thickness]);

        // Solder plate 1
        translate([-solder_t, -(res_depth*(3/8) - res_depth/4)-solder_t, -0.01])
            cube([res_width+solder_t*2, res_depth*(3/8)+solder_t*2, solder_t]);

        // Solder point 2
        translate([-solder_t/2, res_depth*3/4-solder_t/2, 0])
            cube([res_width+solder_t, res_depth/4+solder_t, res_height+solder_t-pi0_thickness]);

        // Solder plate 2
        translate([-solder_t, res_depth-res_depth*(3/8) + (res_depth*(3/8)-res_depth/4)-solder_t, -0.01])
            cube([res_width+solder_t*2, res_depth*(3/8)+solder_t*2, solder_t]);
    }
}

// Zero point
corr = 0.1;


// Colors
pi0_green = [0.3588, 0.5627, 0.1529];
pi0_silver = [0.7529, 0.7529, 0.7529];
pi0_grey = [0.5529, 0.5529, 0.5529];
pi0_yellow = [0.73, 0.73, 0.0353];
pi0_black = [0.05, 0.05, 0.05];
pi0_off_white = [0.9, 0.9, 0.7];
pi0_copper = [0.8311, 0.6889, 0.0978];
pi0_brown = [0.6178, 0.3067, 0.0844];

// Main Parameters
pi0_width = 30; //mm
pi0_length = 64.9; //mm
pi0_thickness = 1.48; //mm
pi0_bevel_r = 2.94; //mm

// Holes
pi0_hole_diameter = 2.74; //mm
pi0_hole_x = 2.2 + pi0_hole_diameter/2; // From edge
pi0_hole_y = pi0_hole_x; // From edge

// Headers
pi0_head_block_height = 2.6; //mm
pi0_head_length = 50.7; //mm
pi0_head_width = 5.0; //mm

pi0_pin_neg_prot = 3.2; //mm
pi0_pin_height = 11.6; //mm
pi0_pin_width = 0.65; //mm
pi0_pin_hole_diameter = 0.93; //mm
pi0_pin_spacing = 3.2 - pi0_pin_width*2; //mm
pi0_pin_rows = 2;
pi0_pin_cols = 20; // 40 total pins

pi0_head_x = 1; //mm from the left side
pi0_head_y = 6.9; //from the front

// Mini-HDMI port
pi0_hdmi_height = 4.8 - pi0_thickness; //mm
pi0_hdmi_width = 11.2; //mm
pi0_hdmi_depth = 7.5; //mm
pi0_hdmi_x = 30.5-pi0_hdmi_depth; // from the left side
pi0_hdmi_y = 6.8; // from the front

// Mini-USB port (There are two)
pi0_mini_usb_height = 2.9; //mm
pi0_mini_usb_width = 8.0; //mm
pi0_mini_usb_depth = 5.6; //mm

pi0_mini_usb_x = 31.2 - pi0_mini_usb_depth;
pi0_mini_usb_y = [37.52, 50.0];

// MicroSD-Card slot
pi0_microsd_height = 2.9 - pi0_thickness; //mm
pi0_microsd_width = 12.0; //mm (Measured in the y direction)
pi0_microsd_depth = 11.4; //mm

pi0_microsd_x = 7.0;
pi0_microsd_y = 1.6;

// Camera port (2 piece part)
pi0_cam_port_length = 4.3; // The length of the whole thing
pi0_cam_flap_length = 1.3;
pi0_cam_base_length = 3.0;

pi0_cam_flap_width = 17.0; //This is the important width
pi0_cam_base_width = 15.8;
pi0_cam_port_thickness = 2.65 - pi0_thickness;

pi0_cam_port_x = 6.6;
pi0_cam_port_y = 65.9 - pi0_cam_port_length;

// CPU block
pi0_cpu_width = 12.0;
pi0_cpu_depth = 12.0;
pi0_cpu_height = 2.65-pi0_thickness;

pi0_cpu_x = 23.1 - pi0_cpu_depth;
pi0_cpu_y = 31.7 - pi0_cpu_width;

module pi_zero(with_headers=true, basic=true) {
    ring_radius = 5.88/2;
    pin_copper_radius = 1.66/2;
    
    // Breadboard
    color(pi0_green)
        difference() {
            cube([pi0_width, pi0_length, pi0_thickness]);

            // Screw Holes (4 total)
            for (x_pos = [pi0_hole_x, pi0_width-pi0_hole_x])
                for (y_pos = [pi0_hole_y, pi0_length-pi0_hole_y])
                    translate([x_pos, y_pos, -corr]) {
                        if(basic) {
                            cylinder(r=pi0_hole_diameter/2, h=pi0_thickness+corr*2);
                        } else {
                            // Remove top layer of board to expose yellow color
                            cylinder(r=ring_radius, h=pi0_thickness+corr*2);
                        }
                    }

            // Bevel for the corners
            for (x_edge = [0, 1])
                for (y_edge = [0, 1])
                    translate([x_edge*pi0_width, y_edge*pi0_length, 0])
                        rotate([0, 0, 90*x_edge-90*y_edge+180*y_edge*x_edge])
                            difference() {
                                translate([-corr, -corr, -corr/2])
                                    cube([pi0_bevel_r+corr, pi0_bevel_r+corr, pi0_thickness+corr]);

                                translate([pi0_bevel_r, pi0_bevel_r, -corr])
                                    cylinder(r=pi0_bevel_r, h=pi0_thickness+corr*2);
                            }

            // Header Pin Holes
            if(!with_headers) {
                translate([pi0_head_x, pi0_head_y, pi0_thickness])
                    translate([(pi0_head_width-(pi0_pin_spacing+pi0_pin_width*2))/2, (pi0_head_length-(pi0_pin_width+(pi0_pin_width+pi0_pin_spacing)*(pi0_pin_cols-1)))/2, -corr-pi0_thickness])
                        for (row = [0 : pi0_pin_rows-1])
                            for (col = [0 : pi0_pin_cols-1])
                                translate([row*(pi0_pin_spacing+pi0_pin_width)+pi0_pin_width/2, col*(pi0_pin_spacing+pi0_pin_width)+pi0_pin_width/2, 0]) {
                                    if(basic) {
                                        cylinder(r=pi0_pin_hole_diameter/2, h=pi0_thickness+corr*2, $fn=15);
                                    } else {
                                        if(row == 1 && col == 0) {
                                            translate([-pin_copper_radius, -pin_copper_radius, 0])
                                                cube([pin_copper_radius*2, pin_copper_radius*2, pi0_thickness+corr*2]);
                                        } else {
                                            cylinder(r=pin_copper_radius, h=pi0_thickness+corr*2, $fn=15);
                                        }
                                    }
                                }
            }

            // Extra Pin Holes
            translate([pi0_head_x, pi0_head_y, pi0_thickness])
                translate([(pi0_head_width-(pi0_pin_spacing+pi0_pin_width*2))/2, (pi0_head_length-(pi0_pin_width+(pi0_pin_width+pi0_pin_spacing)*(pi0_pin_cols-1)))/2, -corr-pi0_thickness])
                    for (row = [pi0_pin_rows : pi0_pin_rows+1])
                        for (col = [pi0_pin_cols-2 : pi0_pin_cols-1])
                            translate([row*(pi0_pin_spacing+pi0_pin_width)+pi0_pin_width/2, col*(pi0_pin_spacing+pi0_pin_width)+pi0_pin_width/2, 0]) {
                                if(basic) {
                                    cylinder(r=pi0_pin_hole_diameter/2, h=pi0_thickness+corr*2, $fn=15);
                                } else {
                                    if ((row+col)%2 != 0) {
                                        translate([-pin_copper_radius, -pin_copper_radius, 0])
                                            cube([pin_copper_radius*2, pin_copper_radius*2, pi0_thickness+corr*2]);
                                    } else {
                                        cylinder(r=pin_copper_radius, h=pi0_thickness+corr*2, $fn=15);
                                    }
                                }
                            }
        }

    if(!basic) {
        // Rings around screw holes
        for (x_pos = [pi0_hole_x, pi0_width-pi0_hole_x])
            for (y_pos = [pi0_hole_y, pi0_length-pi0_hole_y])
                translate([x_pos, y_pos, 0.01]) {
                    color(pi0_yellow)
                        difference() {
                            cylinder(r=ring_radius, h=pi0_thickness-0.02);
                        
                            translate([0,0, -corr])
                                cylinder(r=pi0_hole_diameter/2-0.01, h=pi0_thickness+corr*2);
                        }
                }

        // Rings around pin holes
        color(with_headers ? pi0_silver : pi0_copper)
            translate([pi0_head_x, pi0_head_y, pi0_thickness])
                translate([(pi0_head_width-(pi0_pin_spacing+pi0_pin_width*2))/2, (pi0_head_length-(pi0_pin_width+(pi0_pin_width+pi0_pin_spacing)*(pi0_pin_cols-1)))/2, -corr-pi0_thickness])
                    for (row = [0 : pi0_pin_rows-1])
                        for (col = [0 : pi0_pin_cols-1])
                            translate([row*(pi0_pin_spacing+pi0_pin_width), col*(pi0_pin_spacing+pi0_pin_width), 0])
                                difference() {
                                    translate([pi0_pin_width/2, pi0_pin_width/2, with_headers ? -0.02 : corr+0.01])
                                        if(row == 1 && col == 0) {
                                            translate([-pin_copper_radius, -pin_copper_radius, 0])
                                                cube([pin_copper_radius*2, pin_copper_radius*2, pi0_thickness-0.02]);
                                        } else {
                                            cylinder(r=pin_copper_radius, h=pi0_thickness-0.02, $fn=15);
                                        }

                                    if(!with_headers) {
                                        translate([pi0_pin_width/2, pi0_pin_width/2, -corr])
                                            cylinder(r=pi0_pin_hole_diameter/2, h=pi0_thickness+corr*2, $fn=15);
                                    }
                                }

        // Rings around extra pin holes
        color(pi0_copper)
            translate([pi0_head_x, pi0_head_y, pi0_thickness])
                translate([(pi0_head_width-(pi0_pin_spacing+pi0_pin_width*2))/2, (pi0_head_length-(pi0_pin_width+(pi0_pin_width+pi0_pin_spacing)*(pi0_pin_cols-1)))/2, -corr-pi0_thickness])
                    for (row = [pi0_pin_rows : pi0_pin_rows+1])
                        for (col = [pi0_pin_cols-2 : pi0_pin_cols-1])
                            translate([row*(pi0_pin_spacing+pi0_pin_width)+pi0_pin_width/2, col*(pi0_pin_spacing+pi0_pin_width)+pi0_pin_width/2, corr+0.01])
                                difference() {
                                    if ((row+col)%2 != 0) {
                                        translate([-pin_copper_radius, -pin_copper_radius, 0])
                                            cube([pin_copper_radius*2, pin_copper_radius*2, pi0_thickness-0.02]);
                                    } else {
                                        cylinder(r=pin_copper_radius, h=pi0_thickness-0.02, $fn=15);
                                    }
                                    
                                    translate([0, 0, -corr])
                                        cylinder(r=pi0_pin_hole_diameter/2, h=pi0_thickness+corr*2, $fn=15);
                                }
    }

    if(with_headers) {
        // Headers
        translate([pi0_head_x, pi0_head_y, pi0_thickness]) {
            // The header block
            color(pi0_black)
                cube([pi0_head_width, pi0_head_length, pi0_head_block_height]);

            // The pins
            color(pi0_silver)
            translate([(pi0_head_width-(pi0_pin_spacing+pi0_pin_width*2))/2, (pi0_head_length-(pi0_pin_width+(pi0_pin_width+pi0_pin_spacing)*(pi0_pin_cols-1)))/2, -pi0_pin_neg_prot])
            for (row = [0 : pi0_pin_rows-1])
                for (col = [0 : pi0_pin_cols-1])
                    translate([row*(pi0_pin_spacing+pi0_pin_width), col*(pi0_pin_spacing+pi0_pin_width), 0])
                        cube([pi0_pin_width, pi0_pin_width, pi0_pin_height]);
        }
    }

    // HDMI
    if (basic) {
        // Just a blob of matter...
        color(pi0_silver)
            translate([pi0_hdmi_x, pi0_hdmi_y, pi0_thickness])
                cube([pi0_hdmi_depth, pi0_hdmi_width, pi0_hdmi_height]);
    } else {
        // A more fancy HDMI Port
        hdmi_remove_wid = 1.4;
        hdmi_remove_hig = 1.2;
        hdmi_remove_ang = atan(hdmi_remove_hig/hdmi_remove_wid);
        hdmi_remove_dep = pi0_hdmi_depth - 2.4;
        hdmi_metal_t = 0.3;
        hdmi_insert_w = 7.8;

        color(pi0_silver)
            translate([pi0_hdmi_x, pi0_hdmi_y, pi0_thickness-0.01])
                difference() {
                    cube([pi0_hdmi_depth, pi0_hdmi_width, pi0_hdmi_height]);

                    translate([pi0_hdmi_depth-hdmi_remove_dep, hdmi_remove_wid, 0])
                        rotate([180-hdmi_remove_ang, 0, 0])
                            cube([hdmi_remove_dep+corr, hdmi_remove_wid/cos(hdmi_remove_ang), hdmi_remove_hig]);

                    translate([pi0_hdmi_depth-hdmi_remove_dep, pi0_hdmi_width, hdmi_remove_hig])
                        rotate([hdmi_remove_ang-180, 0, 0])
                            cube([hdmi_remove_dep+corr, hdmi_remove_wid/cos(hdmi_remove_ang), hdmi_remove_hig]);

                    translate([pi0_hdmi_depth-hdmi_remove_dep+corr, hdmi_metal_t, hdmi_metal_t])
                        difference() {
                            cube([hdmi_remove_dep, pi0_hdmi_width-hdmi_metal_t*2, pi0_hdmi_height-hdmi_metal_t*2]);

                            translate([-corr, hdmi_remove_wid-(hdmi_metal_t/sin(hdmi_remove_ang)-hdmi_metal_t), 0])
                                rotate([180-hdmi_remove_ang, 0, 0])
                                    cube([hdmi_remove_dep+corr*2, hdmi_remove_wid/cos(hdmi_remove_ang), hdmi_remove_hig]);

                            translate([0, pi0_hdmi_width-hdmi_metal_t/sin(hdmi_remove_ang), hdmi_remove_hig])
                                rotate([hdmi_remove_ang-180, 0, 0])
                                    cube([hdmi_remove_dep+corr, hdmi_remove_wid/cos(hdmi_remove_ang), hdmi_remove_hig]);
                        }

                }

        color(pi0_black)
            translate([pi0_hdmi_x+corr, pi0_hdmi_y+(pi0_hdmi_width-hdmi_insert_w)/2, pi0_thickness+hdmi_remove_hig+(pi0_hdmi_height-hdmi_remove_hig-hdmi_metal_t*2)/2])
                cube([hdmi_remove_dep, hdmi_insert_w, hdmi_metal_t]);
    }

    // Mini USB Ports
    usb_remove_wid = 1.1;
    usb_remove_hig = 1.3;
    usb_remove_ang = atan(usb_remove_hig/usb_remove_wid);
    usb_remove_dep = pi0_mini_usb_depth+corr;
    usb_top_bev = 0.5;
    usb_metal_t = 0.3;
    usb_insert_w = 3.44;

    for (y_val = pi0_mini_usb_y)
        translate([pi0_mini_usb_x, y_val, pi0_thickness-0.01])
            if (basic) {
                color(pi0_silver)
                    cube([pi0_mini_usb_depth, pi0_mini_usb_width, pi0_mini_usb_height]);
            } else {
                color(pi0_black)
                    translate([corr, (pi0_mini_usb_width-usb_insert_w)/2, usb_remove_hig+(pi0_mini_usb_height-usb_remove_hig-usb_metal_t*2)/2])
                        cube([3/4*usb_remove_dep, usb_insert_w, usb_metal_t]);

                color(pi0_silver)
                    difference() {
                        cube([pi0_mini_usb_depth, pi0_mini_usb_width, pi0_mini_usb_height]);

                        translate([pi0_mini_usb_depth-usb_remove_dep, usb_remove_wid, 0])
                            rotate([180-usb_remove_ang, 0, 0])
                                cube([usb_remove_dep+corr, usb_remove_wid/cos(usb_remove_ang), usb_remove_hig]);

                        translate([pi0_mini_usb_depth-usb_remove_dep, pi0_mini_usb_width, usb_remove_hig])
                            rotate([usb_remove_ang-180, 0, 0])
                                cube([usb_remove_dep+corr, usb_remove_wid/cos(usb_remove_ang), usb_remove_hig]);

                        translate([0, 0, pi0_mini_usb_height-usb_top_bev])
                            difference() {
                                translate([-corr/2, -corr, 0])
                                    cube([pi0_mini_usb_depth+corr, usb_top_bev+corr, usb_top_bev+corr]);

                                rotate([0, 90, 0])
                                    translate([0, usb_top_bev, -corr/2])
                                        cylinder(r=usb_top_bev, h=pi0_mini_usb_depth+corr*2, $fn=12);
                            }

                        translate([0, pi0_mini_usb_width-usb_top_bev, pi0_mini_usb_height-usb_top_bev])
                            difference() {
                                translate([-corr/2, 0, 0])
                                    cube([pi0_mini_usb_depth+corr, usb_top_bev+corr, usb_top_bev+corr]);

                                rotate([0, 90, 0])
                                    translate([0, 0, -corr/2])
                                        cylinder(r=usb_top_bev, h=pi0_mini_usb_depth+corr*2, $fn=12);
                            }

                        translate([usb_metal_t, usb_metal_t, usb_metal_t]) {
                            union() {
                                difference() {
                                    cube([pi0_mini_usb_depth, pi0_mini_usb_width-usb_metal_t*2, pi0_mini_usb_height-usb_metal_t*2]);

                                    translate([pi0_mini_usb_depth-usb_remove_dep, usb_remove_wid, usb_metal_t-usb_metal_t/sin(usb_remove_ang)])
                                        rotate([180-usb_remove_ang, 0, 0])
                                            cube([usb_remove_dep+corr, usb_remove_wid/cos(usb_remove_ang), usb_remove_hig]);

                                    translate([pi0_mini_usb_depth-usb_remove_dep, pi0_mini_usb_width-usb_metal_t*2, usb_remove_hig+usb_metal_t-usb_metal_t/sin(usb_remove_ang)])
                                        rotate([usb_remove_ang-180, 0, 0])
                                            cube([usb_remove_dep+corr, usb_remove_wid/cos(usb_remove_ang), usb_remove_hig]);

                                    translate([0, 0, pi0_mini_usb_height-usb_top_bev-usb_metal_t]) {
                                        difference() {
                                            translate([-corr/2, -corr, 0])
                                                cube([pi0_mini_usb_depth+corr, usb_top_bev-usb_metal_t+corr, usb_top_bev-usb_metal_t+corr]);

                                            rotate([0, 90, 0])
                                                translate([0, usb_top_bev-usb_metal_t, -corr/2])
                                                    cylinder(r=usb_top_bev-usb_metal_t, h=pi0_mini_usb_depth+corr*2, $fn=12);
                                        }

                                        difference() {
                                            translate([-corr/2, pi0_mini_usb_width-usb_top_bev-usb_metal_t, 0])
                                                cube([pi0_mini_usb_depth+corr, usb_top_bev-usb_metal_t+corr, usb_top_bev-usb_metal_t+corr]);

                                            rotate([0, 90, 0])
                                                translate([0, pi0_mini_usb_width-usb_top_bev-usb_metal_t, -corr/2])
                                                    cylinder(r=usb_top_bev-usb_metal_t, h=pi0_mini_usb_depth+corr*2, $fn=12);
                                        }
                                    }
                                }
                            }
                        }
                    }

                
            }

    // SD card Slot
    if (basic) {
        color(pi0_silver)
            translate([pi0_microsd_x, pi0_microsd_y, pi0_thickness])
                cube([pi0_microsd_width, pi0_microsd_depth, pi0_microsd_height]);
    } else {
        sd_metal_t = 0.25;
        sd_front_cutout_d = 1+corr;
        sd_front_cutout_w = 8.6;
        sd_front_cutout_bev = 0.5;
        sd_front_cutout_x = 1.1;
        sd_wire_t = 0.33;
        sd_num_wires = 8;

        color(pi0_silver)
            translate([pi0_microsd_x, pi0_microsd_y, pi0_thickness-0.01])
                difference() {
                    cube([pi0_microsd_width, pi0_microsd_depth, pi0_microsd_height]);
                    
                    translate([sd_metal_t, -sd_metal_t, -corr])
                        cube([pi0_microsd_width-sd_metal_t*2, pi0_microsd_depth-sd_metal_t, pi0_microsd_height-sd_metal_t+corr]);

                    translate([sd_front_cutout_x+sd_front_cutout_bev, -corr, pi0_microsd_height-3/2*sd_metal_t]) {
                        cube([sd_front_cutout_w-sd_front_cutout_bev*2, sd_front_cutout_d, sd_metal_t*2]);
                        
                        translate([-sd_front_cutout_bev, 0, 0])
                            cube([sd_front_cutout_w, sd_front_cutout_d-sd_front_cutout_bev, sd_metal_t*2]);

                        translate([0, sd_front_cutout_d-sd_front_cutout_bev, 0])
                            cylinder(r=sd_front_cutout_bev, h=sd_metal_t*2, $fn=10);
                        
                        translate([sd_front_cutout_w-sd_front_cutout_bev*2, sd_front_cutout_d-sd_front_cutout_bev, 0])
                            cylinder(r=sd_front_cutout_bev, h=sd_metal_t*2, $fn=10);
                    }
                }

        color(pi0_black)
            translate([pi0_microsd_x+sd_metal_t/2, pi0_microsd_y+sd_front_cutout_d-sd_front_cutout_bev, pi0_thickness-0.01])
                cube([pi0_microsd_width-sd_metal_t, pi0_microsd_depth-(sd_front_cutout_d-sd_front_cutout_bev)-sd_metal_t/2, sd_metal_t*2]);

        // Wiring
        color(pi0_silver)
            translate([pi0_microsd_x+sd_front_cutout_x, pi0_microsd_y, pi0_thickness+corr/2]) {
                sd_wire_spacing = (sd_front_cutout_w-sd_wire_t*2*sd_num_wires)/(sd_num_wires+1);
                for(x_adj = [sd_wire_spacing: sd_wire_spacing+sd_wire_t*2 : sd_front_cutout_w])
                    translate([x_adj, 0, 0]) {
                        difference() {
                            cube([sd_wire_t, sd_front_cutout_d, sd_metal_t*2]);

                            translate([-sd_wire_t/2, 0, sd_metal_t])
                                rotate([45, 0, 0])
                                    cube([sd_wire_t*2, sd_front_cutout_d, sd_metal_t*2]);
                        }

                        translate([-sd_wire_t/2, -sd_wire_t/2, -corr+0.01])
                            cube([sd_wire_t*2, sd_wire_t*2, corr]);
                    }
            }
    }

    // CPU chip
    color(pi0_black)
        translate([pi0_cpu_x, pi0_cpu_y, pi0_thickness])
            cube([pi0_cpu_width, pi0_cpu_depth, pi0_cpu_height]);

    // Camera Connector
    if(basic) {
        translate([pi0_cam_port_x, pi0_cam_port_y, pi0_thickness])
            union() {
                color(pi0_off_white)
                    translate([(pi0_cam_flap_width-pi0_cam_base_width)/2, 0, 0])
                        cube([pi0_cam_base_width, pi0_cam_base_length, pi0_cam_port_thickness]);

                color(pi0_black)
                    translate([0, pi0_cam_base_length, 0])
                        cube([pi0_cam_flap_width, pi0_cam_flap_length, pi0_cam_port_thickness]);
            }
    } else {
        // Add camera connector slot
        cam_slot_w = 11.8;
        cam_slot_t = 0.78;
        cam_slot_w2 = 11.16;
        cam_slot_t2 = 0.36;
        cam_slot_x_corr = 0.44;

        cam_port_wire_t = 0.16;
        cam_port_wire_l = 0.9;
        cam_port_wire_h = 1;
        cam_port_wire_w = 10.8;
        cam_port_num_wires = 22;

        translate([pi0_cam_port_x, pi0_cam_port_y, pi0_thickness]) {
            difference() {
                union() {
                    color(pi0_off_white)
                        translate([(pi0_cam_flap_width-pi0_cam_base_width)/2, 0, -0.01])
                            cube([pi0_cam_base_width, pi0_cam_base_length, pi0_cam_port_thickness]);

                    color(pi0_black)
                        translate([0, pi0_cam_base_length, -0.01])
                            cube([pi0_cam_flap_width, pi0_cam_flap_length, pi0_cam_port_thickness]);
                }

                color(pi0_black)
                    translate([(pi0_cam_flap_width-cam_slot_w)/2, pi0_cam_base_length-corr*3/2, -0.02])
                        cube([cam_slot_w, pi0_cam_flap_length+corr*2, cam_slot_t]);
            }

            color(pi0_off_white)
                translate([(pi0_cam_flap_width-cam_slot_w2)/2, pi0_length-pi0_cam_port_y-pi0_cam_flap_length+cam_slot_x_corr, -0.02])
                    cube([cam_slot_w2, pi0_cam_flap_length, cam_slot_t2]);

        }

        // Wiring
        cam_port_wire_spacing = (cam_port_wire_w-cam_port_wire_t*cam_port_num_wires)/(cam_port_num_wires+1);
        color(pi0_silver)
            for(x_adj = [cam_port_wire_spacing: cam_port_wire_spacing+cam_port_wire_t*2 : cam_port_wire_w])
                translate([pi0_cam_port_x+(pi0_cam_flap_width-cam_port_wire_w)/2+x_adj, pi0_cam_port_y-cam_port_wire_l, pi0_thickness]) {
                    difference() {
                        cube([cam_port_wire_t, cam_port_wire_l, cam_port_wire_t*2]);

                        translate([-cam_port_wire_t/2, 0, cam_port_wire_t])
                            rotate([45, 0, 0])
                                cube([cam_port_wire_t*2, cam_port_wire_l, cam_port_wire_t*2]);
                    }

                    translate([-cam_port_wire_t/2, -cam_port_wire_t/2, -corr+0.01])
                        cube([cam_port_wire_t*2, cam_port_wire_t*2, corr]);
                }
    }

    // Extra board components
    if(!basic) {
        comp_heights = [2,    3.13,  2.5,  1.85,  1.9,   2.34,  1.84,  2,     2.07,   ]; //mm
        comp_widths =  [3,    3.5,   2.75, 2.9,   3.2,   1.28,  1.24,  1.13,  1.54,   ]; //mm
        comp_depths =  [3,    4,     1.8,  4.9,   2.4,   2,     1.61,  1.19,  1.17,    ]; //mm
        comp_xs =      [18.97,14.86,27.46, 18.2,  20.82, 23.6,  16.27, 21.11, 21.95,        ];
        comp_ys =      [56.55,59.46,20.2,  45.75, 18.9,  42.72, 48.50, 7.42,  4.89        ];
        comp_colors = [pi0_black, pi0_black, pi0_black, pi0_grey, pi0_silver, pi0_off_white, pi0_silver, pi0_silver, pi0_black];

        for(idx = [0 : len(comp_heights) - 1]) {
            translate([comp_xs[idx]-comp_widths[idx], comp_ys[idx]-comp_depths[idx], pi0_thickness-0.01])
                color(comp_colors[idx])
                    cube([comp_widths[idx], comp_depths[idx], comp_heights[idx]-pi0_thickness]);
        }

        // Resistors
        res_heights = [2.72, 2.72, 2.72,  2.72,  2.70,  2.70,  2.70,  3.12,  2.29,  2.3,   2.39,  2.3,   2.3,       ]; //mm
        res_widths =  [1.23, 1.23, 1.23,  1.23,  1.29,  1.29,  1.32,  1.65,  0.81,  2,     2,     0.95,  0.77,      ]; //mm
        res_depths =  [2,    2,    2,     2,     2.05,  2.05,  1.94,  3.32,  1.62,  2.37,  2.6,   1.70,  1.68,      ]; //mm
        res_rot =     [0,    0,    90,    90,    90,    90,    0,     90,    90,    90,    0,     90,    0,         ];
        res_xs =      [10,   7.8,  19.27, 19.27, 18.30, 18.30, 27.62, 23.93, 21.77, 9.74,  22.20, 16.30, 12.08,     ];
        res_ys =      [28.9, 28.9, 53.40, 51.60, 60.18, 58.21, 48.31, 56.65, 1.71,  34.23, 53.60, 39.57, 40.7,      ];
        // res_color = [0.9111, 0.5911, 0.28];
        res_color = [pi0_brown, pi0_brown, pi0_brown, pi0_brown, pi0_brown, pi0_brown, pi0_brown, pi0_brown, pi0_brown, pi0_black, pi0_black, pi0_black, pi0_black   ];
        res_solder_t = 0.05;

        for(idx = [0 : len(res_heights) - 1]) {
            translate([res_xs[idx]-res_widths[idx]*(90-res_rot[idx])/90, res_ys[idx]-res_depths[idx]*(90-res_rot[idx])/90-res_widths[idx]*res_rot[idx]/90, pi0_thickness-0.01])
                rotate([0, 0, res_rot[idx]])
                    draw_resistor(res_width=res_widths[idx], res_height=res_heights[idx], res_depth=res_depths[idx], res_color=res_color[idx]);
        }
    }
}

pi_zero(with_headers=true, basic=false);
