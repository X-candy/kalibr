// 测试相机标定核心功能
#include <gtest/gtest.h>
#include <iostream>
#include <Eigen/Core>
#include <Eigen/Geometry>
#include <sm/kinematics/quaternion_algebra.hpp>
#include <sm/kinematics/transformations.hpp>
#include <sm/logging.hpp>
#include <aslam/cameras.hpp>
#include <aslam/backend/EuclideanPoint.hpp>
#include <kalibr_errorterms/EuclideanError.hpp>

// 测试1: 验证基本相机几何模型
TEST(CameraCalibrationTests, testPinholeCameraGeometry) {
  using namespace aslam::cameras;

  // 创建一个针孔相机模型
  PinholeProjection<NoDistortion> projection(500.0, 500.0, 320.0, 240.0, 640, 480);
  PinholeCameraGeometry camera(projection);

  // 验证投影
  Eigen::Vector3d point(1.0, 0.0, 5.0);  // 3D点
  Eigen::VectorXd keypoint(2);

  bool success = camera.euclideanToKeypoint(point, keypoint);

  EXPECT_TRUE(success);
  EXPECT_NEAR(keypoint[0], 320.0 + 100.0, 1e-6);  // cx + fx * x/z
  EXPECT_NEAR(keypoint[1], 240.0, 1e-6);            // cy + fy * y/z

  std::cout << "✓ Pinhole camera geometry test passed" << std::endl;
}

// 测试2: 验证欧几里得误差项
TEST(CameraCalibrationTests, testEuclideanError) {
  using namespace kalibr_errorterms;
  using namespace aslam::backend;
  using namespace sm::kinematics;

  // 创建一个测量值
  Eigen::Vector3d measurement(1.0, 2.0, 3.0);
  Eigen::Matrix3d invR = Eigen::Matrix3d::Identity();

  // 创建设计变量
  EuclideanPoint point(Eigen::Vector3d(1.0, 2.0, 3.0));

  // 创建误差项
  EuclideanError error(measurement, invR, point.toExpression());

  // 验证误差为零（预测值等于测量值）
  double errorValue = error.evaluateError();
  EXPECT_NEAR(errorValue, 0.0, 1e-6);

  std::cout << "✓ Euclidean error term test passed" << std::endl;
}

// 测试3: 验证变换操作
TEST(CameraCalibrationTests, testTransformations) {
  using namespace sm::kinematics;

  // 创建一个随机旋转
  Eigen::Vector4d q = quatIdentity(); // 使用单位旋转使测试可预测
  Eigen::Vector3d t(1.0, 2.0, 3.0);

  // 创建变换矩阵 - 需要先将四元数转换为旋转矩阵
  Eigen::Matrix3d C = quat2r(q);
  Eigen::Matrix4d T = rt2Transform(C, t);

  // 验证变换点
  Eigen::Vector3d p(0.0, 0.0, 0.0);
  Eigen::Vector3d p_transformed = (T * p.homogeneous()).hnormalized();

  EXPECT_NEAR(p_transformed[0], t[0], 1e-6);
  EXPECT_NEAR(p_transformed[1], t[1], 1e-6);
  EXPECT_NEAR(p_transformed[2], t[2], 1e-6);

  std::cout << "✓ Transformation test passed" << std::endl;
}

