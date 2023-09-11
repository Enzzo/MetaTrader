#include <Object.mqh>

class model : CObject{
public:
    model(){};
   ~model(){};

   virtual void proccessing() = 0;
};