function monte_carlo_pi()
    A = 1.0; % squeres side
    simulations_array = [10, 100, 1000, 5228, 5384, 10000];

    fprintf('a = %f\n', A);

    for i = 1:length(simulations_array)
        number_of_simulations = simulations_array(i);
        times_inside = find_times_inside_circle(number_of_simulations, A);
        pi_estimate = calculate_pi(number_of_simulations, times_inside);
        fprintf('For N=%d pi = %f\n', number_of_simulations, pi_estimate);
    end
end

function val = generate_random_number(A)
    val = (rand() * A) - (A / 2);
end

function inside = is_inside_circle(x, y, A)
    radius = A / 2;
    if (x^2 + y^2) <= radius^2
        inside = 1;
    else
        inside = 0;
    end
end

function counter = find_times_inside_circle(N, A)
    counter = 0;
    for i = 1:N
        randomX = generate_random_number(A);
        randomY = generate_random_number(A);
        if is_inside_circle(randomX, randomY, A)
            counter = counter + 1;
        end
    end
end

function pi_val = calculate_pi(N, times_inside)
    pi_val = 4.0 * (times_inside / N);
end

