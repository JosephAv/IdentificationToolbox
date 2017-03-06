function provaslider

uicontrol('Style', 'slider', 'units' , 'normalized', 'position', [0.05 0.05 0.9 0.05], 'Callback', @sliderCallback);
%     uicontrol(...     
%         'units'   , 'normalized',...    %// so yo don't have to f*ck with pixels
%         'style'   , 'slider',...        
%         'position', [0.05 0.05 0.9 0.05],...
%         'min'     , 1,...               %// Make the A between 1...
%         'max'     , 1500,...              %// and 10, with initial value
%         'value'   , index,...           %// as set above.
%         'callback', @sliderCallback);   %// This is called when using the arrows
%                                         %// and/or when clicking the slider bar
    function sliderCallback(hObject, evt)
        fprintf('Slider value is: %d\n', floor(get(hObject, 'Value')*1000) );
        clear g
        visual_fun( floor(get(hObject, 'Value'))  )
    end
end