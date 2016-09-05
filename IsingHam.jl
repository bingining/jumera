# Ising model with transverse magnetic field h (critical h=1 by default)
# Returns three-site Ising Hamiltonian (8x8 matrix), and the highest energy eigenvalue
function build_H_Ising(h=1.0)
    h::Array{Complex{Float64},6}
    D_max::Float64
    X = [0 1; 1 0]
    Z = [1 0; 0 -1]
    I = eye(2)
    XX = kron(X,X)
    ZI = kron(Z,I)
    IZ = kron(I,Z)
    H2 = -(XX + h/2*(ZI+IZ))
    H = H2 / 3  # See below for an explanation of the 1/3.
    for n = 3:9
        eyen2 = eye(2^(n-2))
        # Terms at the borders of the blocks of three that get grouped together
        # need to be normalized differently from the ones that are within blocks.
        factor = (n == 4 || n == 7) ? 1/2 : 1/3
        H = kron(H, I) + kron(eyen2, H2)*factor
    end
    D, V = eig(Hermitian(H))
    D_max = D[end]
    # subtract largest eigenvalue, so that the spectrum is negative
    H = H - eye(2^9)*D_max
    h = reshape(H, (8,8,8,8,8,8)) |> complex
    return h, D_max
end