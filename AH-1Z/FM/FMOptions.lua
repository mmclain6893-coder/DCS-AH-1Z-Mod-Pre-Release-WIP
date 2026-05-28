-- Minimal FMOptions.lua stub
-- This file exists so `dofile(current_mod_path.."/FM/FMOptions.lua")` succeeds.
-- Add shared FM helper definitions here if needed by other FM files.

-- Placeholder: nothing required for basic suspension positioning.

CenteringShiftX = 0.0;--�������� ���������
CenteringShiftY = 0.0;
CenteringShiftZ = 0.0;
StickVibrationxMax=0.2;-- ������������ ���������� ����� �� ������ ������ � +
StickVibrationxMin=-0.2;-- ������������ ���������� ����� �� ������ ������ � -
StickVibrationFrequency=1;-- ������� ��������� �����
StickWithoutHydroVelocity=1/2; -- �������� ���� �����

critForceFuselage = 150000.0-- 110000.0
critImpulseFuselage = 0.0
critForceSkid = 70000.0-- 50000.0
critImpulseSkid = 0.0
critForceTail = 35000.0-- 25000.0
critImpulseTail = 0.0
critForceStabilizer = 15000.0--  15000.0-
critImpulseStabilizer = 0

cushionStrength=0.235 -- ���� ��������� �������
cushionWeakening=0.40 -- ������� �������� ���� ��������� ������� ��
cushionDensityCoef =0.0

critSpeedFuselage=14.0
critSpeedSkid=5.0
critSpeedTail=8.0

maxCentrifugalRotorForce = 150.0
breakingUnbalance = 0.02

CargoMass = 0.0; --����� ����������� �����

deltaFlappingForCrash = -2.22;

PilotHelperOn = false -- �������� � ����������

-- // ����

CargoModelling=false; -- ������������� ����� 
CargoGround=false;-- ��������� ����� �� ����� ��� �������� � ������� ������.


MediumDynamic=false; -- ��������� ��� ������� ��������� �������� ���������
SimpleHooking=false; -- ��������� ���������� �������� � ������� 20 � �� �����.

sticktimelag=0.5;

CargoDempher=.0; --������� �����;

--// ������� �����

CargoHeight=7.0;
dCargoHeight=2.0;
dxzCargo=2.0;
HoveringTime=5.0;