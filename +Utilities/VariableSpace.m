classdef VariableSpace < Object.Object
    properties (Access = private)
        space
    end
    
    events
        spaceChanged
    end
    
    methods (Access = public)
        function this=VariableSpace()
            this.space=struct();
        end
        
        function addListener(this, handler)
            this.addlistener('spaceChanged',handler);
        end
        
        function varargout=subsref(this, name)
            if numel({name.type})==1 && strcmp(name.type, '.')
                varargout{1}=this.space.(name.subs);
            else
                try
                    varargout=builtin('subsref', this, name);
                catch
                    builtin('subsref', this, name);
                end
            end
        end
        
        function this=subsasgn(this, name, value)
            if numel({name.type})==1 && strcmp(name.type, '.')
                this.space.(name.subs)=value;
                this.notify('spaceChanged',...
                    Utilities.SpaceChangedEvent(name.subs,value));
            else
                this=builtin('subsasgn', this, name, value);
            end
        end
    end
end