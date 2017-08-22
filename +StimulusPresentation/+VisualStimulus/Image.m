classdef Image < StimulusPresentation.Stimulus
    properties (Access = private)
        size
        position
        data
        name
        fileAddress
    end
    
    methods (Access = public)
        function this=Image(size, position)
            this@StimulusPresentation.Stimulus('Image');
            this.size=size;
            this.position=position;
            this.data=[];
            this.name='';
            this.fileAddress='';
        end
        
        function size=getSize(this)
            size=this.size;
        end
        
        function position=getPosition(this)
            position=this.position;
        end
        
        function data=getData(this)
            data=this.data;
        end
        
        function name=getName(this)
            name=this.name;
        end
        
        function fileAddress=getFileAddress(this)
            fileAddress=this.fileAddress;
        end
        
        function fromFile(this, fileAddress, name)
            this.fileAddress=fileAddress;
            this.name=name;
        end
        
        function fromMatrix(this, data, name)
            this.data=data;
            this.name=name;
        end
    end
end