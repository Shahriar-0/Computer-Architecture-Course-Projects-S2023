from typing import Any

class Type:
    def __init__(self, input: str) -> None:
        self.input = input
        
    def __call__(self, *args: Any, **kwds: Any) -> Any:
        return self.__assemble()
    
    def __assemble(self) -> str:
        pass

class R_Type(Type):
    def __init__(self, input: str) -> None:
        super.__init__(input)
        
    def __assemble(self) -> str:
        self.input
        

class Assembler:
    pass

