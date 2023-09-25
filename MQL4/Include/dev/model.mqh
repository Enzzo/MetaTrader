#include <Object.mqh>

// +--------------------------------------+
// |              class model             |
// +--------------------------------------+
class model : public CObject{
public:
   virtual ~model(){};

   virtual void proccessing() = 0;

protected:
   model(){};
};
