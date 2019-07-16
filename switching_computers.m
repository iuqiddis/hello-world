%switching computers

computer_type = computer;
switch computer_type
    case 'GLNXA64'
        [~, computer_name] = system('uname -n');
        computer_name = strcat(computer_name);
        if strcmp(computer_name, 'lizzy')
            base_path = '/khazaddum/alanine/sarmad_upenn/';
        elseif strcmp(computer_name, 'ghazali')
            base_path = '/home/sms/';
        else
            base_path = '/khazaddum/';
        end
    case 'MACI64'
        base_path = '/Users/iuqiddis/';
end
