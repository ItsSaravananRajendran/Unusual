--this script draws history graphs

require 'cairo'

cpu_table={}
down_table={}
up_table= {}
function conky_main()
    if conky_window == nil then return end
    local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, conky_window.width, conky_window.height)
    cr = cairo_create(cs)
    local updates=tonumber(conky_parse('${updates}'))
    --setup tables, need one table for each graph to be drawn 
    if updates<=5 then
    end--end of table setup 
    if updates>5 then

    	--set color, red green blue alpha , values 0 to 1
        --red,green,blue,alpha=0.5,0.75,1,1--fully opaque blue

        --un comment this for green
        --red,green,blue,alpha=0,0.80,0,1--fully opaque green

        --un comment this for black
        red,green,blue,alpha=0,0,0,1--fully opaque black

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
	    hdd_width = 10
		hdd_used= tonumber(conky_parse('${fs_used_perc}'))
        

		ram_bar_start_x = 196	
	    ram_bar_start_y = 110
	    ram_max_height= 102
	    ram_slope = 0.045423279421576979
	    ram_width = 10.5
	    ram_used = tonumber(conky_parse('${memperc}'))
       
	   
	    swap_bar_start_x = 110	
	    swap_bar_start_y = 177
	    swap_max_height= 97
	    swap_slope =  -1.4157995848709555
	    swap_width = 10
	    swap_used = tonumber(conky_parse('${swapperc}'))
       
	    min_center_x = 223
	    min_center_y = 296.5
	    min_radius = 16.3
	    min_max = 60
	    min_width = 5.2
	    mins=os.date("%M")

	    hours_center_x = 312
	    hours_center_y = 341.2
	    hours_radius = 50.7
	    hours_width = 6.5
	    hours_max = 12
	    hours=os.date("%I")

		battery_center_x = 293.8
	    battery_center_y = 70
	    battery_radius = 51
	    battery_width = 8.7
	    battery_max = 100	    
	    battery = tonumber(conky_parse('${battery_percent BAT1}'))

	    down_graph_x = 73.5
	    down_graph_y = 274.2
	    down_graph_width = 31
	    down_max = 11
	    down_radius = 13
        down = math.log(tonumber(conky_parse('${downspeedf wlo1}')))
        --down = 10
        if down <  0 then down = 0 end
        
        up_graph_x = 73.5
	    up_graph_y = 274.2
	    up_graph_width = 31
	    up_max = 11
	    up_radius = 45
        up = math.log(tonumber(conky_parse('${upspeedf wlo1}')))
        --up = 10
        if up <  0 then up = 0 end
        


        cpu0 = tonumber(conky_parse('${cpu cpu0}'))
        cpu1 = tonumber(conky_parse('${cpu cpu1}'))
        cpu2 = tonumber(conky_parse('${cpu cpu2}'))
        cpu3 = tonumber(conky_parse('${cpu cpu3}'))
        --you will need to copy and paste this section for each different graph you want to draw
        --SETTINGS ##############################################
        --set value to display
        gvalue=conky_parse('${cpu}')
        --set max value for the above value
        max_value=100
      
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

        for i = 1, tonumber(table_length) do
            if down_table[i+1]==nil then down_table[i+1]=0 end
				down_table[i]=down_table[i+1]
            if i==table_length then
                down_table[table_length]=down
            end
        end--of for loop


        for i = 1, tonumber(table_length) do
            if up_table[i+1]==nil then up_table[i+1]=0 end
				up_table[i]=up_table[i+1]
            if i==table_length then
                up_table[table_length]=(-1*up)
            end
        end--of for loop

 		--call graph drawing function
        draw_graph(down_table,down_max,table_length,down_graph_x ,down_graph_y,red,green,blue,alpha,width,14,down_radius,50)
        draw_start_line(Cpu_graph_radius+55,30,2,235)
        

        --call graph drawing function
        draw_graph(cpu_table,max_value,table_length,Cpu_graph_center_x ,Cpu_graph_center_y,red,green,blue,alpha,width,30,Cpu_graph_radius,40)
        draw_start_line(Cpu_graph_radius,64,2,40)
        --end of graph setup

 		--call graph drawing function
        draw_graph(up_table,up_max,table_length,up_graph_x ,up_graph_y,red,green,blue,alpha,width,14,up_radius,50)



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
		
		
		draw_ring(battery_width,battery_center_x,battery_center_y,battery_radius,battery_max,battery,132)
		
		--test_ring(min_center_x,min_center_y,min_radius,min_max,mins)
		--testbar()
		--test_ring()

    end-- if updates>5


    cairo_destroy(cr)
    cairo_surface_destroy(cs)
    cr=nil
end-- end main function

function draw_graph(data,max_value,table_length,c_x,c_y,red,green,blue,alpha,width,ring_max_height,radius,angle)
    inc=(360) / table_length
    pro = (ring_max_height/  max_value)
    

    cairo_set_source_rgba (cr,red,green,blue,alpha)
    for i=1, table_length do
       bar_height=pro *data[i]
       draw_line_in_circle(radius, bar_height, 1, angle, c_x,c_y)
       angle = angle-inc
       angle = angle % 360
    end

end--of function draw_graph

function draw_line_in_circle(offset, length, width, degree,c_x,c_y)
    cairo_set_line_width(cr, width)
    point = (math.pi / 180) * degree
    start_x = 0 + (offset * math.sin(point))
    start_y = 0 - (offset * math.cos(point))
    end_x = 0 + ((offset + length) * math.sin(point))
    end_y = 0 - ((offset + length) * math.cos(point))
    cairo_move_to(cr, start_x +  c_x, start_y +  c_y)
    cairo_line_to(cr, end_x +  c_x, end_y +  c_y)
    cairo_stroke(cr)
end

function draw_circle(x,y,r,cpu )
    prop = (2 * r)/100
    height_for_usage = prop*cpu
    Start_angle = (math.asin((height_for_usage-r)/r)) - math.pi
    two = (270*(math.pi/180))
    End_angel = (two) - (Start_angle - two)
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
	cairo_set_source_rgba (cr,red,green,blue,alpha)
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
	cairo_set_line_width(cr,31)
    cairo_arc (cr,73.5,274.2,29.5,0,6.28)
    cairo_stroke(cr)
end