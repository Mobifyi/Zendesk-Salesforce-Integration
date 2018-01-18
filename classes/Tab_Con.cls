public class Tab_Con {
    
    public Integer randomSuffix{get;set;}
    
    public Tab_Con(){
        randomSuffix = getRandomNumber(1000000);
    }
    
    private Integer getRandomNumber(Integer size){
        Double d = Math.random() * size;
        return d.intValue();
    }
}