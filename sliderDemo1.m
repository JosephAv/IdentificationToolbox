function sliderDemo

    f = figure(1);

    %// Some simple to plot function (with tuneable parameter)
    x = 0:0.1:2*pi;
    y = @(A) A*sin(x);

    %// Make initial plot
    A = 1;
    p = plot(x, y(A));
    axis tight
    axis([0 2*pi -10 10])

    %// re-position the axes to make room for the slider
    set(gca, 'position', [0.1 0.25 0.85 0.7]);

    %// initialize the slider
    h = uicontrol(...
        'parent'  , f,...        
        'units'   , 'normalized',...    %// so yo don't have to f*ck with pixels
        'style'   , 'slider',...        
        'position', [0.05 0.05 0.9 0.05],...
        'min'     , 1,...               %// Make the A between 1...
        'max'     , 10,...              %// and 10, with initial value
        'value'   , A,...               %// as set above.
        'callback', @sliderCallback);   %// This is called when using the arrows
                                        %// and/or when clicking the slider bar


    %// THE MAGIC INGREDIENT
    %// ===========================

    hLstn = handle.listener(h,'ActionEvent',@sliderCallback); %#ok<NASGU>
    %// (variable appears unused, but not assigning it to anything means that 
    %// the listener is stored in the 'ans' variable. If "ans" is overwritten, 
    %// the listener goes out of scope and is thus destroyed, and thus, it no 
    %// longer works.

    %// ===========================


    %// The slider's callback:
    %//    1) clears the old plot
    %//    2) computes new values using the (continuously) updated slider values
    %//    3) re-draw the plot and re-set the axes settings
    function sliderCallback(~,~)
        delete(p);
        p = plot(x, y(get(h,'value')));
        axis tight
        axis([0 2*pi -10 10])
    end

end