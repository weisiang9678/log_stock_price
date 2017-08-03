!///////////////////////////////////////////////////////////////////////////////
program stock_price
  implicit none

  real, parameter :: pi = 3.14159265359
  real :: miu, sigma, dt, ds, t, s
  real :: s_input, miu_input, sigma_input
  real :: s_deter, s_upper, s_lower, var, sd, ci
  real :: ranval1, ranval2, eps
  integer :: i
  character(len=30) :: output

  write(*,'(1/)')
  write(*,'(a)') '    |----------------------------|'
  write(*,'(a)') '    |                            |'
  write(*,'(a)') '    |   Stochastic stock price   |'
  write(*,'(a)') '    |   Lognormal model          |'
  write(*,'(a)') '    |   by Tan Wai Kiat          |'
  write(*,'(a)') '    |                            |'
  write(*,'(a)') '    |----------------------------|'
  write(*,'(1/)')

  write(*,'(a)', advance = "no") "    Enter S0, miu, sigma, confidence interval: "
  read(*,*) s_input, miu_input, sigma_input, ci

  do i = 1, 100
     s = s_input
     miu = miu_input
     sigma = sigma_input
     
     dt = 1.0/252.0
     t = 0.0
     
     call random_seed
     write(output,9) i
     open(6, file = output)
     do while (t .le. 1.0)
        call random_number(ranval1)
        call random_number(ranval2)
        
        eps = -1.0*sqrt(-2*log(ranval1))*cos(2*pi*ranval2)
        s = s*exp((miu - sigma*sigma/2)*dt + sigma*eps*sqrt(dt))
        write(6,19) t, s, eps, ds
        
        s = s + ds
        if (s .lt. 0) s = 0.0
        t = t + dt
     end do
     close(6)
  end do

  open(16, file = 'deterministic.txt')
  t = 0.0
  s = s_input
  write(16,19) t, s, s, s
  do while (t .le. 1.0)
     t = t + dt
     s_deter = s*exp(miu*t)
     var = s*s*exp(2*miu*t)*(exp(sigma*sigma*t) - 1)
     sd = sqrt(var)
     s_upper = s + ci*sd
     s_lower = s - ci*sd
     if (s_lower .lt. 0) s_lower = 0.0
     write(16,19) t, s_deter, s_upper, s_lower
  end do
  close(16)
  
  call system('gnuplot -p plot.gnu')
  write(*,*)
  write(*,*) '   Simulation completed!'
9   format('output_',i0,'.txt')
19  format(f6.3, 3f12.6)
end program stock_price
!///////////////////////////////////////////////////////////////////////////////
