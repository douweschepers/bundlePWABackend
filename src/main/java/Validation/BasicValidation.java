package Validation;

public class BasicValidation {
	public boolean checkIfFilledString(String input) {
		Boolean result = false;
		if(input.isEmpty()!= true)
		{
			result = true;
		}
		return result;
	}
	public boolean checkIfFilledInt(int input) {
		Boolean result = false;
		if(input != 0)
		{
			result = true;
		}
		return result;
	}
	public boolean checkNumber(int input){
		Boolean result = false;
		if(input == (int)input)
		{
			result = true;
		}
		return result;
	}
	public boolean isLetters(String input){
		boolean result = false;
		char[] chars = input.toCharArray();
		
	    for (char c : chars) {
	        if(Character.isLetter(c)) {
	            result = true;
	        }
	    }
	    return result;
	}

}
