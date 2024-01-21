--VARIABLES
local NIBP_SYS_MIN = 100
local NIBP_SYS_MAX = 140
local NIBP_DYS_MIN = 60
local NIBP_DYS_MAX = 100

local keyboard_control
  
Patients = {};
function init_patient_profile(patient_number)
    Patients[patient_number] = {
      name = "Fulano " .. patient_number,
      sex = "NA",
      age = 66,
      BPM = 60, 
      NIBP = {SYS = 120, DYS = 80},
      BT = 36,
      SPO2 = 99,
      FR = 14
    };
end


local patient_number
--- @param gre#context mapargs
function retrieve_patient_values(mapargs)
--TODO: Your code goes here...
  patient_number = mapargs.Patient
  if (Patients[patient_number]==nil) then
    init_patient_profile(patient_number)
  end
  
  --Monitor info panel data
  gre.set_value("Infor_Panel_Layer.Patient_Name.text", Patients[patient_number].name)
  gre.set_value("Infor_Panel_Layer.Patient_Age.text","Sex: " .. Patients[patient_number].sex)
  gre.set_value("Infor_Panel_Layer.Patient_Sex.text","Age: " .. Patients[patient_number].age)
  gre.set_value("Infor_Panel_Layer.BPM.text","BPM: " .. Patients[patient_number].BPM)
  gre.set_value("Infor_Panel_Layer.NIBP.text","NIBP: " ..  Patients[patient_number].NIBP.SYS .. "/" .. Patients[patient_number].NIBP.DYS )
  gre.set_value("Infor_Panel_Layer.BT.text","BT: " .. Patients[patient_number].BT .. "°")
  gre.set_value("Infor_Panel_Layer.SPO2.text","SPO2: " .. Patients[patient_number].SPO2 .. "%")
  gre.set_value("Infor_Panel_Layer.FR.text","FR: " .. Patients[patient_number].FR)
end


--- @param gre#context mapargs
local x = 10
local i= 0
function draw_graph(mapargs)
--TODO: Your code goes here...
  i=i+1
  if(i==10)then
    i=0
  end
  x = x+1
  if(x == 296)then
    x=10
    gre.set_value("Graph_Layer.First_Graph.points","");
    gre.set_value("Graph_Layer.Second_Graph.points","");
    gre.set_value("Graph_Layer.Third_Graph.points","");
  end
-- FIRST GRAPH
  local points = gre.get_value("Graph_Layer.First_Graph.points");
  local valor_ecg = 10 * math.sin(2 * math.pi * i / 15)
  points = points.." "..x..","..math.floor(valor_ecg+47)
  gre.set_value("Graph_Layer.First_Graph.points",points)
  
-- SECOND GRAPH  
  local points = gre.get_value("Graph_Layer.Second_Graph.points");
  local valor_ecg = 10 * math.sin(2 * math.pi * i / 30)
  points = points.." "..x..","..math.floor(valor_ecg+47)
  gre.set_value("Graph_Layer.Second_Graph.points",points)
  
-- SECOND GRAPH  
  local points = gre.get_value("Graph_Layer.Third_Graph.points");
  local valor_ecg = 20 * math.sin(2 * math.pi * i / 20)
  points = points.." "..x..","..math.floor(valor_ecg+47)
  gre.set_value("Graph_Layer.Third_Graph.points",points)  
end


--- @param gre#context mapargs
function check_info_panel(mapargs)
--TODO: Your code goes here...
  local seed = (math.random()-0.5)*2
  
  local BPM = Patients[patient_number].BPM+seed*5
  local NIBP_SYS = math.floor(Patients[patient_number].NIBP.SYS+seed*3)  
  local NIBP_DYS = math.floor(Patients[patient_number].NIBP.DYS+seed)
  local BT =  math.floor(Patients[patient_number].BT+seed+0.5)
  local SPO2 = Patients[patient_number].SPO2
  local FR = Patients[patient_number].FR
  
  -- CHECK ALARM
  local BPM_MIN = gre.get_value("Values_Panel_layer.BPM_MIN.text")+0
  --print(BPM_MIN<30)
  local BPM_MAX = gre.get_value("Values_Panel_layer.BPM_MAX.text")+0
  --print(BPM_MAX)
  --NIBP uses local variables
  local BT_MIN = gre.get_value("Values_Panel_layer.BT_MIN.text")+0
  --print(BT_MIN)
  local BT_MAX = gre.get_value("Values_Panel_layer.BT_MAX.text")+0
  --print(BT_MAX)
  local SPO2_MIN = gre.get_value("Values_Panel_layer.SPO2_MIN.text")+0
  --print(SPO2_MIN)
  local FR_MIN = gre.get_value("Values_Panel_layer.FR_MIN.text")+0
  --print(FR_MIN)
  local FR_MAX = gre.get_value("Values_Panel_layer.FR_MAX.text")+0
  --print(FR_MAX)


  if((not (BPM_MIN<=BPM and BPM<=BPM_MAX)) or
     (not (NIBP_SYS_MIN<=NIBP_SYS and NIBP_SYS<=NIBP_SYS_MAX)) or
     (not (NIBP_DYS_MIN<=NIBP_DYS and NIBP_DYS<=NIBP_DYS_MAX)) or
     (not (BT_MIN<=BT and BT<=BT_MAX)) or
     (not (SPO2_MIN<=SPO2)) or
     (not (FR_MIN<=FR and FR<=FR_MAX))
  )then
    gre.set_value("Infor_Panel_Layer.Ok_Signal.image","images/Warn_Signal.png")
  else
    gre.set_value("Infor_Panel_Layer.Ok_Signal.image","images/Ok_Signal.png")
  end
  
  
  gre.set_value("Infor_Panel_Layer.BPM.text","BPM: " .. BPM)
  gre.set_value("Infor_Panel_Layer.NIBP.text","NIBP: " .. NIBP_SYS .. "/" .. NIBP_DYS)
  gre.set_value("Infor_Panel_Layer.BT.text","BT: " ..BT.. "°")
  gre.set_value("Infor_Panel_Layer.SPO2.text","SPO2: " ..SPO2.. "%")
  gre.set_value("Infor_Panel_Layer.FR.text","FR: " .. FR)
end


--- @param gre#context mapargs
function change_NIBP(mapargs)
--TODO: Your code goes here...
  if(gre.get_value("Values_Panel_layer.NIBP_sel_button.text")=="SYS")then
    gre.set_value("Values_Panel_layer.NIBP_sel_button.text","DYS")
    
    NIBP_SYS_MIN = gre.get_value("Values_Panel_layer.NIBP_MIN.text")+0
    NIBP_SYS_MAX = gre.get_value("Values_Panel_layer.NIBP_MAX.text")+0
    
    gre.set_value("Values_Panel_layer.NIBP_MIN.text",NIBP_DYS_MIN)
    gre.set_value("Values_Panel_layer.NIBP_MAX.text",NIBP_DYS_MAX)
  else
    gre.set_value("Values_Panel_layer.NIBP_sel_button.text","SYS")
    
    NIBP_DYS_MIN = gre.get_value("Values_Panel_layer.NIBP_MIN.text")+0
    NIBP_DYS_MAX = gre.get_value("Values_Panel_layer.NIBP_MAX.text")+0
    
    gre.set_value("Values_Panel_layer.NIBP_MIN.text",NIBP_SYS_MIN)
    gre.set_value("Values_Panel_layer.NIBP_MAX.text",NIBP_SYS_MAX)    
  end
end


--- @param gre#context mapargs
function Draw_keyboard(mapargs)
--TODO: Your code goes here...
  local data = {}
  
  data["Modify_values_layer.Keyboard.text.1.1"] = "Ok"
  data["Modify_values_layer.Keyboard.text_color.1.1"] = gre.rgb(0, 255, 128)
  data["Modify_values_layer.Keyboard.text.1.2"] = "Quit"
  data["Modify_values_layer.Keyboard.text_color.1.2"] = gre.rgb(255, 60, 128) 
  data["Modify_values_layer.Keyboard.text.1.3"] = "Del"
  data["Modify_values_layer.Keyboard.text_color.1.3"] = gre.rgb(255, 255, 0)
  
  local x=9
  for i =2,4,1 do 
    for j=1,3,1 do
      data["Modify_values_layer.Keyboard.text."..i.."."..j] = x
      x=x-1
    end
  end
  data["Modify_values_layer.Keyboard.text.5.2"] = "0"
  data["Modify_values_layer.Keyboard.text.5.3"] = "."
  
  gre.set_data(data)
  gre.set_table_attrs("Modify_values_layer.Keyboard", data)

end


--- @param gre#context mapargs
function button_pressed(mapargs)
--TODO: Your code goes here...
  local row = mapargs.context_row
  local col =  mapargs.context_col
  local data = gre.get_value("Modify_values_layer.Keyboard.text."..row.."."..col)
  local current_string

  if(data~="")then
    current_string = gre.get_value("Modify_values_layer.input_value.text_value")
    if (data=="Ok") then
      if(tonumber(current_string)~=nil)then
        gre.set_value(keyboard_control..".text",current_string)
        local data={}
        data.hidden = 1
        gre.set_layer_attrs("Modify_values_layer", data)
      end
    elseif (data=="Quit") then
      local data={}
      data.hidden = 1
      gre.set_layer_attrs("Modify_values_layer", data)  
    elseif (data=="Del") then
      gre.set_value("Modify_values_layer.input_value.text_value",string.sub(current_string, 1, -2))
    else
      if(string.len(current_string)<=6)then
        gre.set_value("Modify_values_layer.input_value.text_value",current_string..data)
      end
    end
  end
end


--- @param gre#context mapargs
function show_keyboard(mapargs)
--TODO: Your code goes here...
  keyboard_control = mapargs.context_control
  local data={}
  data.hidden = 0
  gre.set_layer_attrs("Modify_values_layer", data) 
end
