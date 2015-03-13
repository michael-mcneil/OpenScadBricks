//bricks - a simple library to create bricks which fit with Lego brand and other blocks
//by Michael McNeil - TVCOG
//Thanks for the original dimensions from
//http://www.robertcailliau.eu/Lego/Dimensions/zMeasurements-en.xhtml

//constants
brickGap = 0.2;  //distance left between bricks
wallThick = 1.2; //thickness of brick sides
res = 100; //used for resolution


//primitive elements - mostly used internall

module knob()
//one knob for the top of a brick
{
    cylinder(h=1.8, r=2.4, $fn=100);
}



module brickShell(x,y)
//the 'shell' of a full-depth brick, without knobs on top or cylinders on the bottom
//x & y are the dimensions in 'knobs'
{
    translate([0,0,-9.6])
        difference()
        {
                cube([(x*8)-brickGap,(y*8)-brickGap,9.6]);
                translate([wallThick,wallThick,-1])
                    cube([(x*8)-brickGap-(2*wallThick),(y*8)-brickGap-(2*wallThick),8.6]);
        }
}

module bottomCyls(x,y)
//the cylinders underneath a shell which grip the knobs from bricks underneath
{
    module bottomCyl()
    //a single cylinder
    {
        difference()
        {
            cylinder(h=8.6, r=3.25, $fn=100);
            translate([0,0,-1])
                cylinder(h=8.6, r=2.8, $fn=100);
        }
    }
    for (i=[0:(x-1)])
    {
        for (j=[0:(y-1)])
        {
            if ((i!=0) && (j!=0))//both are odd
            {
                      translate([i*8,j*8,-9.6]) 
                        bottomCyl();
            }
        }
    }
}

module topKnobs(x,y)
//used to generate a set of knobs for the top of a brick
//x & y are the dimensions in 'knobs'
{
    for (i=[0:(x-1)])
    {
        for (j=[0:(y-1)])
        {
            translate([4+i*8,4+j*8,0])
            knob();
            if ((i!=0) && (j!=0))//both are odd
            {
                      translate([i*8,j*8,-9.6]) 
                        bottomCyl();
            }
        }
    }
}


module brick(x,y)
//generates a complete brick with shell, knobs, and bottom grip cylinders
//x & y are the dimensions in 'knobs'

{
    brickShell(x,y);
    topKnobs(x,y);
    bottomCyls(x,y);
}

module topPlate(x,y)
//x & y are the dimensions in 'knobs'
//generates a third-height top plate
{
    intersection()
    {
        brick(x,y);
        translate([0,0,-3.2])
            cube([8*x,8*y,3.2+1.8]); // 13 ht plus knob ht
    }
}

        
