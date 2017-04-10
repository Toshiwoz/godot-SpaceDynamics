# Defines an orbit using keplerian elements.
#  a: Semimajor axis [m]
#  e: Eccentricity [-]
#  i: Inclination [rad]
#  raan: Right ascension of ascending node (:math:`\Omega`) [rad]
#  arg_pe: Argument of periapsis (:math:`\omega`) [rad]
#  M0: Mean anomaly at `ref_epoch` (:math:`M_{0}`) [rad]


const MAX_ITERATIONS = 100
var pi = PI

export(float) var ea = 0
export(float) var eccentricity = 0.0167
export(float) var mean_radius = 100.46435
export(float) var true_anom = 100.46435

func _ready():
#	ea = eccentric_anomaly_from_mean(eccentricity, mean_radius)
#	ea = eccentric_anomaly_from_true(eccentricity, true_anom)
#	ea = uvw_from_elements(0, 0.641, pi/2, pi)
	var position = Vector3(-6142438.668, 3492467.560, -25767.25680)
	var velocity = Vector3(505.8479685, 942.7809215, 7435.922231)
	var earth_mu = 3.986e14
	var aa = elements_from_state_vector(position, velocity, earth_mu)
	self.get_node("Label").set_text(str(aa.print_values()))
	
	
# Anomaly conversions

func eccentric_anomaly_from_mean(e, M, tolerance=1e-14):
	"""Convert mean anomaly to eccentric anomaly.
	Implemented from [A Practical Method for Solving the Kepler Equation][1]
	by Marc A. Murison from the U.S. Naval Observatory
	[1]: http://murison.alpheratz.net/dynamics/twobody/KeplerIterations_summary.pdf
	"""
	var Mnorm = fmod(M, 2 * pi)
	var E0 = M + (-1 / 2 * pow(e, 3) + e + (pow(e, 2) + 3 / 2 * cos(M) * pow(e, 3)) * cos(M)) * sin(M)
	var dE = tolerance + 1
	var count = 0
	var E = 0
	while dE > tolerance:
		var t1 = cos(E0)
		var t2 = -1 + e * t1
		var t3 = sin(E0)
		var t4 = e * t3
		var t5 = -E0 + t4 + Mnorm
		var t6 = t5 / (1 / 2 * t5 * t4 / t2 + t2)
		E = E0 - t5 / ((1 / 2 * t3 - 1 / 6 * t1 * t6) * e * t6 + t2)
		dE = abs(E - E0)
		E0 = E
		count += 1
		if count == MAX_ITERATIONS:
			printerr("Did not converge after %d iterations. (e=%d, M=%d)" % [MAX_ITERATIONS, e, M])
	return E
	
func eccentric_anomaly_from_true(e, f):
	"""Convert true anomaly to eccentric anomaly."""
	var E = atan2(sqrt(1 - pow(e, 2)) * sin(f), e + cos(f))
	E = mod(E, 2 * pi)
	return E
	
func mean_anomaly_from_eccentric(e, E):
	"""Convert eccentric anomaly to mean anomaly."""
	return E - e * sin(E)

func mean_anomaly_from_true(e, f):
	"""Convert true anomaly to mean anomaly."""
	var E = eccentric_anomaly_from_true(e, f)
	return E - e * sin(E)

func true_anomaly_from_eccentric(e, E):
	"""Convert eccentric anomaly to true anomaly."""
	return 2 * atan2(sqrt(1 + e) * sin(E / 2), sqrt(1 - e) * cos(E / 2))

func true_anomaly_from_mean(e, M, tolerance=1e-14):
	"""Convert mean anomaly to true anomaly."""
	var E = eccentric_anomaly_from_mean(e, M, tolerance)
	return true_anomaly_from_eccentric(e, E)
	
	
# Orbital element helper functions

func orbit_radius(a, e, f):
	"""Calculate scalar orbital radius."""
	return (a * (1 - pow(e, 2))) / (1 + e * cos(f))

func elements_for_apsides(apocenter_radius, pericenter_radius):
	"""Calculate planar orbital elements for given apside radii."""
	var a = (apocenter_radius + pericenter_radius) / 2
	var e = (apocenter_radius - pericenter_radius) / (apocenter_radius + pericenter_radius)
	return {a = a, e = e}

func uvw_from_elements(i, raan, arg_pe, f):
    # Return U, V, W unit vectors.
    #  float i: Inclination (:math:`i`) [rad]
    #  float raan:  Right ascension of ascending node (:math:`\Omega`) [rad]
    #  float arg_pe: Argument of periapsis (:math:`\omega`) [rad]
    #  float f: True anomaly (:math:`f`) [rad]
    # :return: Radial direction unit vector (:math:`U`)
    # :return: Transversal (in-flight) direction unit vector (:math:`V`)
    # :return: Out-of-plane direction unit vector (:math:`W`)
    # :rtype: :py:class:`numpy.ndarray`
	var u = arg_pe + f

	var sin_u = sin(u)
	var cos_u = cos(u)
	var sin_raan = sin(raan)
	var cos_raan = cos(raan)
	var sin_i = sin(i)
	var cos_i = cos(i)

	var U = Vector3(cos_u * cos_raan - sin_u * sin_raan * cos_i,
		cos_u * sin_raan + sin_u * cos_raan * cos_i,
		sin_u * sin_i)

	var V = Vector3(-sin_u * cos_raan - cos_u * sin_raan * cos_i,
		-sin_u * sin_raan + cos_u * cos_raan * cos_i,
		cos_u * sin_i)

	var W = Vector3(sin_raan * sin_i,
		-cos_raan * sin_i,
		cos_i)

	return {U = U,V = V, W = W}

func angular_momentum(position, velocity):
	"""Return angular momentum.
	:param position: Position (r) [m]
	:type position: :py:class:`~orbital.utilities.Position`
	:param velocity: Velocity (v) [m/s]
	:type velocity: :py:class:`~orbital.utilities.Velocity`
	:return: Angular momentum (h) [N·m·s]
	:rtype: :py:class:`~orbital.utilities.XyzVector`
	"""
	return position.cross(velocity)


func node_vector(angular_momentum):
	"""Return node vector.
	:param angular_momentum: Angular momentum (h) [N·m·s]
	:type angular_momentum: :py:class:`numpy.ndarray`
	:return: Node vector (n) [N·m·s]
	:rtype: :py:class:`~orbital.utilities.XyzVector`
	"""
	return Vector3(0, 0, 1).cross(angular_momentum)

func eccentricity_vector(position, velocity, mu):
	"""Return eccentricity vector.
	# :param position: Position (r) [m]
	# :type position: :py:class:`~orbital.utilities.Position`
	# :param velocity: Velocity (v) [m/s]
	# :type velocity: :py:class:`~orbital.utilities.Velocity`
	# :param float mu: Standard gravitational parameter (:math:`mu`) [m :sup:`3` ·s :sup:`-2`]
	# :return: Eccentricity vector (ev) [-]
	# :rtype: :py:class:`~orbital.utilities.XyzVector`
	"""
	
	# This isn't required, but get base arrays so that return value isn't an
	# instance of Position().
	var r = position
	var v = velocity
	var ev = 1 / mu * ((pow(v.length(), 2) - mu / r.length()) * r - r.dot(v) * v)
	return ev

func specific_orbital_energy(position, velocity, mu):
	"""Return specific orbital energy.
	:param position: Position (r) [m]
	:type position: :py:class:`~orbital.utilities.Position`
	:param velocity: Velocity (v) [m/s]
	:type velocity: :py:class:`~orbital.utilities.Velocity`
	:param mu: Standard gravitational parameter (:math:`mu`) [m :sup:`3` ·s :sup:`-2`]
	:type mu: float
	:return: Specific orbital energy (E) [J/kg]
	:rtype: float
	"""
	var r = position
	var v = velocity
	return pow(v.length(), 2) / 2 - mu / r.length()

func elements_from_state_vector(r, v, mu):
	var h = angular_momentum(r, v)
	var n = node_vector(h)
	
	var ev = eccentricity_vector(r, v, mu)
	
	var E = specific_orbital_energy(r, v, mu)
	
	var a = -mu / (2 * E)
	var e = ev.length()
	
	var SMALL_NUMBER = 1e-15
	var raan = 0
	var arg_pe = 0
	var f
	
	# Inclination is the angle between the angular
	# momentum vector and its z component.
	var i = acos(h.z / h.length())
	
	if abs(i - 0) < SMALL_NUMBER:
	    # For non-inclined orbits, raan is undefined;
	    # set to zero by convention
		raan = 0
		if abs(e - 0) < SMALL_NUMBER:
	        # For circular orbits, place periapsis
	        # at ascending node by convention
			arg_pe = 0
		else:
	        # Argument of periapsis is the angle between
	        # eccentricity vector and its x component.
			arg_pe = acos(ev.x / ev.length())
	else:
	    # Right ascension of ascending node is the angle
	    # between the node vector and its x component.
		raan = acos(n.x / n.length())
		if n.y < 0:
			raan = 2 * pi - raan
	
	    # Argument of periapsis is angle between
	    # node and eccentricity vectors.
		arg_pe = acos(n.dot(ev) / (n.length() * ev.length()))
	
	if abs(e - 0) < SMALL_NUMBER:
		if abs(i - 0) < SMALL_NUMBER:
	        # True anomaly is angle between position
	        # vector and its x component.
			f = acos(r.x / r.length())
			if v.x > 0:
				f = 2 * pi - f
		else:
	        # True anomaly is angle between node
	        # vector and position vector.
			f = acos(n.dot(r) / (n.length() * r.length()))
			if n.dot(v) > 0:
				f = 2 * pi - f
	else:
		if ev.z < 0:
			arg_pe = 2 * pi - arg_pe
	
	    # True anomaly is angle between eccentricity
	    # vector and position vector.
		f = acos(ev.dot(r) / (ev.length() * r.length()))
	
		if r.dot(v) < 0:
			f = 2 * pi - f
	
	return OrbitalElements.new(a, e, i, raan, arg_pe, f)

# User helper functions

func radius_from_altitude(altitude, body):
	"""Return radius for a given altitude."""
	return altitude + body.mean_radius


func altitude_from_radius(radius, body):
	"""Return altitude for a given radius."""
	return radius - body.mean_radius


func impulse_from_finite(acceleration, duration):
	"""Return impulsive velocity delta for constant thrust finite burn."""
	return acceleration * duration

# Math functions

func mod(x, y):
	"""Return the modulus after division of x by y.
	Python's x % y is best suited for integers, and math.mod returns with the
	sign of x.
	This function is modelled after Matlab's mod() function.
	"""
	if is_nan(x) or is_nan(y):
		return float('NaN')
	if is_inf(x):
		printerr("math domain error")
	if is_inf(y):
		return x
	if y == 0:
		return x
	
	var n = floor(x / y)
	return x - n * y

func divmod(x, y):
	"""Return quotient and remainder from division of x by y."""
	return [floor(x / y), mod(x, y)]
	

# OBJECTS

class OrbitalElements:
	var a
	var e
	var i
	var raan
	var arg_pe
	var f
	
	func _init(i_a, i_e, i_i, i_raan, i_arg_pe, i_f):
		a = i_a
		e = i_e
		i = i_i
		raan = i_raan
		arg_pe = i_arg_pe
		f = i_f
		
	func print_values():
		return (str(a) + " - " + str(e)+ " - " + str(i) + " - " + str(raan) + " - " + str(arg_pe) + " - " + str(f))
		
	