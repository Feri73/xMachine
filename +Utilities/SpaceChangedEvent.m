classdef SpaceChangedEvent < event.EventData
    properties (Access = public)
        name
        value
    end
    
    methods (Access = public)
        function this=SpaceChangedEvent(name,value)
            this.name=name;
            this.value=value;
        end
    end
end