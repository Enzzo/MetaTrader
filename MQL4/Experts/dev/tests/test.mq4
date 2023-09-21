#property copyright "Sergey"
#property link "http://mql5.com/enzzo"
#property version "1.00"

class some_class{
public:
   some_class() 
      : _ptr(new int(1)){};
      
  ~some_class();
   
private:
   int* _ptr;
};

int OnInit(){
   some_class sc;
   return INIT_SUCCEEDED;
}

void OnTick(){

}

