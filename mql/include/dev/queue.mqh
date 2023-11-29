#include <Object.mqh>

template<typename T>
class queue : public CObject{
private:
    T m_array[];

public:
    queue(){};
    queue(const queue& other);
    queue operator=(const queue& other);

    T front() const;
    T back() const;

    bool empty() const;
    int size() const;

    void push(const T value);
    T emplace(const T value);
    T pop();

private:
    void swap(queue<T>& other);
};

template<typename T>
queue::queue(const queue& other){
    T temp_array[];
    ArrayCopy(temp_array, other.m_array);
    ArrayCopy(m_array, temp_array);
}

template<typename T>
queue queue::operator=(const queue& other){
    T temp_array[];
    ArrayCopy(temp_array, other.m_array);
    ArrayCopy(m_array, temp_array);
    return this;
}

template<typename T>
T queue::front() const{
    if(empty()){
        // TODO
        return EMPTY_VALUE;
    }
    return m_array[0];
}

template<typename T>
T queue::back() const{
    if(empty()){
        // TODO
        return EMPTY_VALUE;
    }
    return m_array[size() - 1];
}

template<typename T>
bool queue::empty() const{
    return size() == 0;
}

template<typename T>
int queue::size() const{
    return ArraySize(m_array);
}

template<typename T>
void queue::push(const T value){
    int new_size = size() + 1;
    ArrayResize(m_array, new_size);
    m_array[new_size-1] = value;
}

template<typename T>
T queue::pop() {
    if(empty()){
        // TODO
        return EMPTY_VALUE;
    }
    T value = m_array[0];
    
    for(int i = size() - 1; i > 0; --i){
        m_array[i - 1] = m_array[i];
    }

    ArrayResize(m_array, size() - 1);
    return value;
}

template<typename T>
void queue::swap(queue<T>& other){
    T temp_array[];
    ArrayCopy(temp_array, other.m_array);
    ArrayCopy(other.m_array, m_array);
    ArrayCopy(m_array, temp_array);
}