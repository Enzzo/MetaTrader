#include <Object.mqh>

class model : public CObject{
public:
    model(){};
   ~model(){};

   virtual void proccessing() = 0;

protected:
};