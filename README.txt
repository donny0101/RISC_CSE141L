Explain which programs/features work:

We were able to get all 3 programs running! 

Explain which programs/features don't work and what challenges you 
faced when implementing your design:

There were several challenges we faced when implementing our design, but
the most obvious one was due to how our registers were designed, we were 
only able to use registers r4->r7 in the first position of an instruction 
as the first register we used 3 bits but restricted the second register 
to just 2. We initially had the issue of assigning a value to a higher 
register and then unless using STR  then load, we couldn't grab that value 
immediately. We had to create another opCode that allowed us to assign the 
higher register to the lower register. 