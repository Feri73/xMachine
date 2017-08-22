classdef Keyboard < Object.Object
    properties (Access = private)
        deviceAddress
    end
    
    methods (Access = public)
        function this=Keyboard(deviceAddress)
            if exist('deviceAddress','var')
                this.deviceAddress=deviceAddress;
            else
                this.deviceAddress=[];
            end
        end
        
        function keyMap=getKeyMap(this)
            if isempty(this.deviceAddress)
                [~,~,charMap] = KbCheck();
            else
                [~,~,charMap] = KbCheck(this.deviceAddress);
            end
            keyMap=KbName(find(charMap));
            if isempty(keyMap)
                keyMap={};
            elseif ischar(keyMap)
                keyMap={keyMap};
            end
        end
        
        function handler=getInputSignalHandler(this)
            handler=@signalHandler;
            function value=signalHandler(~)
                value=this.getKeyMap();
            end
        end
    end
end