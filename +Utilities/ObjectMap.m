classdef ObjectMap < Object.Object
    properties (Access = private)
        map
    end
    
    methods (Access = private)
        function setMap(this,map)
            this.map=map;
        end
    end
    
    methods (Access = public)
        function this=ObjectMap()
            this.map=containers.Map('KeyType','uint64','ValueType','any');
        end
        
        function objectMap=clone(this)
            objectMap=Object.ObjectMap();
            objectMap.setMap(this.map);
        end
        
        function size=size(this)
            size=length(this.map);
        end
        
        function varargout=subsref(this, key)
            if numel({key.type})==1 && strcmp(key.type, '()')
                keyId=key.subs{1}.getId();
                try
                    varargout{1}=this.map(keyId);
                catch ex
                    if strcmp(ex.identifier,'MATLAB:Containers:Map:NoKey')
                        varargout{1}=Object.Object.Null;
                    else
                        rethrow(ex);
                    end
                end
            else
                try
                    [varargout{1:nargout}]=builtin('subsref', this, key);
                catch
                    builtin('subsref', this, key);
                end
            end
        end
        
        function this=subsasgn(this, key, value)
            if numel({key.type})==1 && strcmp(key.type, '()')
                keyId=key.subs{1}.getId();
                this.map(keyId)=value;
            else
                this=builtin('subsasgn', this, key, value);
            end
        end
    end
end