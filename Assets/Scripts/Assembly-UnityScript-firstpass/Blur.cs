using System;
using UnityEngine;

[Serializable]
public class Blur : PostEffectsBase
{
	public enum BlurType
	{
		StandardGauss = 0,
		SgxGauss = 1,
	}

	public int downsample;
	public float blurSize;
	public int blurIterations;
	public BlurType blurType;
	public Shader blurShader;
}
