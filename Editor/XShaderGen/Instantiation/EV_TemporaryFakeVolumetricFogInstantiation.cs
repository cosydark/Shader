using System.Collections.Generic;
using UnityEngine;
#if XRP_SHADER_INSTANTIATION_META
{
    "ClassName": "EV_TemporaryFakeVolumetricFogShader",
    "Name": "XRender/Environment/TemporaryFakeVolumetricFog",
    "OutputPath": "Assets/Res/Shader/SurfaceShaderLibrary/EV_TemporaryFakeVolumetricFog.shader",
    "MM": "TemporaryFakeVolumetricFog",
    "SM": "SHADING_MODEL_EMISSIVE",
    "Owner": "QP4B",
    "Usage": "Environment",
    "Desc": "TemporaryFakeVolumetricFog",
    "PMs": [],
    "Config": [
        "SetSurfaceType(SurfaceShaderConfig.SurfaceTypeOption.Option)",
        "SetOptionTransQueue(SurfaceShaderConfig.TransQueue.Option)",
        "SetAlphaBlendMode(SurfaceShaderConfig.BlendModeOption.Option)",
        "SetOptionCullMode(SurfaceShaderConfig.CullModeOption.Option)",
        "SetOptionAlphaCutoffEnable(ShaderOptionFlag.OptionalDisable)",
        "SetOptionZWrite(ShaderOptionFlag.AlwaysEnable)",
        "SetOptionTransparentResponsiveAA(ShaderOptionFlag.OptionalDisable)"
    ]
}
#endif

namespace UnityEditor.XRender.XShaderGen.Instantiation
{
    [SurfaceShaderInstantiationAttribute]
    public class EV_TemporaryFakeVolumetricFogShader : XSurfaceShader
    {
        public override string GetName() => "XRender/Environment/TemporaryFakeVolumetricFog";
        public override string GetOwner() => "QP4B";
        public override string GetDesc() => "TemporaryFakeVolumetricFog";
        public override SurfaceShaderUsage GetUsage() => SurfaceShaderUsage.Environment;
        public override string GetGenerateShaderPath() => "Assets/Res/Shader/SurfaceShaderLibrary/EV_TemporaryFakeVolumetricFog.shader";
        protected override string GetMaterialModelName() => "TemporaryFakeVolumetricFog";
        protected override string GetShadingModelName() => "SHADING_MODEL_EMISSIVE";
        protected override List<PluginModelDesc> InitPluginModelDescs() => new()
        {
            // new PluginModelDesc {name = "DefaultPluginModel", needMultiCompile = false},
        };
        protected override void AdditionalConfig(SurfaceShaderConfig config)
        {
            config.SetSurfaceType(SurfaceShaderConfig.SurfaceTypeOption.Transparent);
            config.SetOptionTransQueue(SurfaceShaderConfig.TransQueue.Trans);
            config.SetAlphaBlendMode(SurfaceShaderConfig.BlendModeOption.Additive);
            config.SetOptionCullMode(SurfaceShaderConfig.CullModeOption.Back);
            config.SetOptionAlphaCutoffEnable(ShaderOptionFlag.AlwaysDisable);
            config.SetOptionZWrite(ShaderOptionFlag.AlwaysDisable);
            config.SetOptionTransparentResponsiveAA(ShaderOptionFlag.OptionalDisable);
            config.SetOptionSupportDecal(ShaderOptionFlag.AlwaysDisable);
            config.SetOptionDecalLayer(SurfaceShaderConfig.DecalLayer.Layer1);
        }
    }
}
//ss:[[-1962556735]]

