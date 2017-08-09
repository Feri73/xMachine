classdef Rectangle < StimulusPresentation.Stimulus
    properties (Access = private)
        size
        position
        color
        width
    end
    
    methods (Access = public)
        function this=Rectangle(size, position, color, width)
            this@StimulusPresentation.Stimulus('Rectangle');
            this.size=size;
            this.position=position;
            this.color=color;
            this.width=width;
        end
        
        function size=getSize(this)
            size=this.size;
        end
        
        function position=getPosition(this)
            position=this.position;
        end
        
        function color=getColor(this)
            color=this.color;
        end
        
        function width=getWidth(this)
            width=this.width;
        end
    end
end