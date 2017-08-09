classdef Sound < StimulusPresentation.Stimulus
    properties (Access = private)
        data
        frequency
        name
        fileAddress
    end
    
    methods (Access = public)
        function this=Sound()
            this@StimulusPresentation.Stimulus('Sound');
            this.data=[];
            this.frequency=0;
            this.name='';
            this.fileAddress='';
        end
        
        function data=getData(this)
            data=this.data;
        end
        
        function frequency=getFrequency(this)
            frequency=this.frequency;
        end
        
        function name=getName(this)
            name=this.name;
        end
        
        function fileAddress=getFileAddress(this)
            fileAddress=this.fileAddress;
        end
        
        function fromFile(this, fileAddress, name)
            this.name=name;
            this.fileAddress=fileAddress;
        end
        
        function fromVector(this, data, frequency, name)
            this.data=data;
            this.frequency=frequency;
            this.name=name;
        end
    end
end