--this script draws history graphs

require 'cairo'

cpu_table={}
function conky_main()
    if conky_window == nil then return end
    local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, conky_window.width, conky_window.height)
    cr = cairo_create(cs)
    local updates=tonumber(conky_parse('${updates}'))
    --setup tables, need one table for each graph to be drawn 
    if updates<=5 then
    end--end of table setup 
    if updates>5 then
        Cpu_graph_MaxWidth = 30
        Cpu_graph_center_x = 191
        Cpu_graph_center_y = 189
        Cpu_graph_radius = 47
        Core_circle_radius = 12.1
        Core_circle_x0=99
        Core_circle_y0=154
        Core_circle_x1=115
        Core_circle_y1=125
        Core_circle_x2=141
        Core_circle_y2=102
        Core_circle_x3=174
        Core_circle_y3=90

        hdd_bar_start_x = 269.53017467581	
	    hdd_bar_start_y = 173
	    hdd_max_height= 95
	    hdd_slope = 1.4200284888259636
	    hdd_width = 8
		hdd_used= tonumber(conky_parse('${fs_used_perc}'))
        

		ram_bar_start_x = 196	
	    ram_bar_start_y = 110
	    ram_max_height= 102
	    ram_slope = 0.045423279421576979
	    ram_width = 9
	    ram_used = tonumber(conky_parse('${memperc}'))
       
	   
	    swap_bar_start_x = 110	
	    swap_bar_start_y = 177
	    swap_max_height= 97
	    swap_slope =  -1.4157995848709555
	    swap_width = 10
	    swap_used = tonumber(conky_parse('${swapperc}'))
       
	    min_center_x = 223
	    min_center_y = 296.5
	    min_radius = 16.5
	    min_max = 60
	    min_width = 4
	    mins=os.date("%M")

	    hours_center_x = 312
	    hours_center_y = 341.2
	    hours_radius = 50
	    hours_width = 5.5
	    hours_max = 12
	    hours=os.date("%I")

        
        cpu0 = tonumber(conky_parse('${cpu cpu0}'))
        cpu1 = tonumber(conky_parse('${cpu cpu1}'))
        cpu2 = tonumber(conky_parse('${cpu cpu2}'))
        cpu3 = tonumber(conky_parse('${cpu cpu3}'))
        --you will need to copy and paste this section for each different graph you want to draw
        --SETTINGS ##############################################
        --set coordinates of bottom left corner of graph
        blx,bly=200,200
        --set value to display
        gvalue=conky_parse('${cpu}')
        --set max value for the above value
        max_value=100
        --set color, red green blue alpha , values 0 to 1
        red,green,blue,alpha=0,0,1,1--fully opaque white
        --set bar width
        width=2
        --set table length, ie how many values you want recorded
        table_length=300
        --END OF SETTINGS #########################################
        for i = 1, tonumber(table_length) do
            if cpu_table[i+1]==nil then cpu_table[i+1]=0 end
				cpu_table[i]=cpu_table[i+1]
            if i==table_length then
                cpu_table[table_length]=tonumber(gvalue)
            end
        end--of for loop
        --call graph drawing function
        draw_graph(cpu_table,max_value,table_length,blx,bly,red,green,blue,alpha,width)
        --end of graph setup


        -- call for core usage display
        draw_circle(Core_circle_x0,Core_circle_y0,Core_circle_radius,cpu0)
        draw_circle(Core_circle_x1,Core_circle_y1,Core_circle_radius,cpu1)
        draw_circle(Core_circle_x2,Core_circle_y2,Core_circle_radius,cpu2)
        draw_circle(Core_circle_x3,Core_circle_y3,Core_circle_radius,cpu3)

        -- call for HHD  usage
        draw_line_graph( hdd_width,hdd_used,hdd_max_height,hdd_bar_start_x,hdd_bar_start_y,hdd_slope)

        --call for RAM usage
		draw_line_graph( ram_width,ram_used,ram_max_height,ram_bar_start_x,ram_bar_start_y,ram_slope)
		
		--call for swap usage
		draw_line_graph( swap_width,swap_used,swap_max_height,swap_bar_start_x,swap_bar_start_y,swap_slope)
		
		--call for mins ring
		draw_ring(min_width,min_center_x,min_center_y,min_radius,min_max,mins,270)
		

		--call for hours ring
		draw_ring(hours_width,hours_center_x,hours_center_y,hours_radius,hours_max,hours,270)
		
		--test_ring(min_center_x,min_center_y,min_radius,min_max,mins)
		--testbar()
		--test_ring()

    end-- if updates>5


    cairo_destroy(cr)
    cairo_surface_destroy(cs)
    cr=nil
end-- end main function

function draw_graph(data,max_value,table_length,blx,bly,red,green,blue,alpha,width)
    angle=40
    inc=(360) / table_length
    pro = (30/  max_value)
    

    cairo_set_source_rgba (cr,0.5,.75,1,alpha)
    draw_start_line(Cpu_graph_radius,65,2,angle)
    
    for i=1, table_length do
       bar_height=pro *data[i]
       draw_line_in_circle(Cpu_graph_radius, bar_height, 1, angle)
       angle = angle-inc
       angle = angle % 360
    end

end--of function draw_graph

function draw_line_in_circle(offset, length, width, degree)
    cairo_set_line_width(cr, width)
    point = (math.pi / 180) * degree
    start_x = 0 + (offset * math.sin(point))
    start_y = 0 - (offset * math.cos(point))
    end_x = 0 + ((offset + length) * math.sin(point))
    end_y = 0 - ((offset + length) * math.cos(point))
    cairo_move_to(cr, start_x +  Cpu_graph_center_x, start_y +  Cpu_graph_center_y)
    cairo_line_to(cr, end_x +  Cpu_graph_center_x, end_y +  Cpu_graph_center_y)
    cairo_stroke(cr)
end

function draw_circle(x,y,r,cpu )
    prop = (2 * r)/100
    height_for_usage = prop*cpu
    Start_angle = (math.asin((height_for_usage-r)/r)) - math.pi
    two = (270*(math.pi/180))
    End_angel = (two) - (Start_angle - two)
    cairo_set_source_rgba (cr,0.5,.75,1,alpha)
    cairo_arc (cr,x,y,r,End_angel,Start_angle)
    cairo_fill_preserve (cr)
    cairo_stroke (cr)
end

function draw_start_line(offset,length,width,degree)
    cairo_set_line_width(cr, width)
    point = (math.pi / 180) * degree
    start_x = 0 + (offset * math.sin(point))
    start_y = 0 - (offset * math.cos(point))
    end_x = 0 + ((offset + length) * math.sin(point))
    end_y = 0 - ((offset + length) * math.cos(point))
    cairo_move_to(cr, start_x +  Cpu_graph_center_x, start_y +  Cpu_graph_center_y)
    cairo_line_to(cr, end_x +  Cpu_graph_center_x, end_y +  Cpu_graph_center_y)
    cairo_stroke (cr)
end

function draw_line_graph( width,bar_coverage,bar_height,start_x,start_y,point)
	cairo_set_line_width(cr,width)
	height = (bar_height/100)*bar_coverage
    cairo_move_to(cr, start_x , start_y )
   	end_x = start_x + (height * math.sin(point))
   	end_y = start_y - (height * math.cos(point))
   	cairo_line_to(cr, end_x , end_y )
    cairo_stroke (cr)
end

function draw_ring(width,c_x,c_y,radius,max_parts,usage,start_angle)
	start_angle = (math.pi/180)*start_angle
	end_angel = start_angle + ((2*math.pi*usage)/max_parts)
	cairo_set_line_width(cr,width)
	cairo_set_source_rgba (cr,0.5,.75,1,alpha)
    cairo_arc (cr,c_x,c_y,radius,start_angle,end_angel)
    cairo_stroke(cr)	

end

function testbar( )
	-- body
	cairo_set_line_width(cr,1)
	cairo_move_to(cr, 110 , 177 )
    cairo_line_to(cr, 14, 162 )
    cairo_stroke (cr)
end

function test_ring()
	cairo_set_line_width(cr,5.5)
	cairo_set_source_rgba (cr,0.5,.75,1,alpha)
    cairo_arc (cr,312,341.2,50,0,6.28)
    cairo_stroke(cr)
end