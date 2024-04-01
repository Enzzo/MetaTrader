#include <dev/observable.mqh>

class lbr_model : public observable{
    double price_;

public:
    lbr_model():price_(0.1234){

    }

    double get_price() const {
        return price_;
    }

    void set_price(const double price){
        price_ = price;
        notify_update();
    }
};