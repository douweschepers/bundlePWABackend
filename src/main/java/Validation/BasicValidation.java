package Validation;

public class BasicValidation {
	public boolean checkIfFilled(String input) {
		Boolean result = false;
		if(input.isEmpty()!= true)
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

}
